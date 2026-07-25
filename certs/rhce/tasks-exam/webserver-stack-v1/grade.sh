#!/usr/bin/env bash
# Exam-format grading: 100% live-outcome assertion on both prod hosts, no
# inspection of the student's playbook source anywhere below (TODO.md Phase
# 12a's mandate for tasks-exam/ — stricter than the training pool's hybrid
# style, which still keeps a module-name grep or two as a gate).
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || { fail "invalid YAML in $PLAYBOOK_FILE"; exit 1; }

run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
if [[ $? -ne 0 ]]; then
  fail "ansible-playbook run failed"
  echo "$run_out" | tail -30
  exit 1
fi

# Home page: correct banner + each host's own hostname. /etc/hosts on the
# control node already resolves node3/node4 (topology_create wrote it), so
# curl can reach them directly by inventory name — no need to look up IPs.
for host in node3 node4; do
  hostname_actual=$(as_student "ansible prod -i $INVENTORY_FILE --limit $host -m command -a 'hostname -s'" 2>&1 | tail -1 | tr -d '[:space:]')
  page=$(curl -s --max-time 5 "http://$host/" || true)
  [[ "$page" == *"$BANNER_TEXT"* ]] \
    || fail "$host: home page does not contain the required banner text"
  [[ -n "$hostname_actual" && "$page" == *"$hostname_actual"* ]] \
    || fail "$host: home page does not show this host's own hostname"
done

# firewalld: http reachable, permanently and immediately. -b (become) is
# required — firewall-cmd's D-Bus query is denied by polkit for a plain SSH
# session running as the unprivileged student user (confirmed live: fails
# with "Authorization failed" without -b, succeeds with it).
fw_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'firewall-cmd --query-service=http' -b" 2>&1)
[[ "$(echo "$fw_out" | grep -c '^yes$')" -eq 2 ]] \
  || fail "http service is not enabled (runtime) on both prod hosts"

fw_perm_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'firewall-cmd --permanent --query-service=http' -b" 2>&1)
[[ "$(echo "$fw_perm_out" | grep -c '^yes$')" -eq 2 ]] \
  || fail "http service is not permanently enabled on both prod hosts"

# SELinux: a persistent fcontext policy rule must exist for WEB_ROOT (matches
# the pattern used by tasks/ch04-playbooks/selinux-playbook-v1's grade.sh) —
# proves the labeling survives a full relabel, not just a one-off chcon.
# semanage also needs -b for the same reason as firewall-cmd above.
policy_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'semanage fcontext -l' -b" 2>&1)
policy_hits=$(echo "$policy_out" | grep -F "${WEB_ROOT}(/.*)?" | grep -cE 'httpd_sys_content_t|public_content_t')
[[ $policy_hits -eq 2 ]] \
  || fail "no persistent SELinux fcontext rule for ${WEB_ROOT}(/.*)? on both prod hosts"

ctx_out=$(as_student "ansible prod -i $INVENTORY_FILE -m command -a 'ls -Zd $WEB_ROOT'" 2>&1)
ctx_hits=$(echo "$ctx_out" | grep -cE 'httpd_sys_content_t|public_content_t')
[[ $ctx_hits -eq 2 ]] \
  || fail "$WEB_ROOT's actual on-disk SELinux context is wrong on one or both prod hosts"

[[ $errors -eq 0 ]] && exit 0 || exit 1
