#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook $PLAYBOOK_FILE does not exist"; exit 1; }
python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "ansible-playbook --syntax-check failed"

grep -q "yum_repository\|ansible.builtin.yum_repository" "$PLAYBOOK_FILE" \
  || fail "playbook does not use yum_repository module"
grep -qi "hosts:\s*all" "$PLAYBOOK_FILE" \
  || fail "playbook does not target all hosts"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    repo_out=$(as_student "ansible all -i $INVENTORY_FILE -m shell -a 'cat /etc/yum.repos.d/*.repo'" 2>&1)
    [[ "$(echo "$repo_out" | grep -c '\[BaseOS\]')" -eq 5 ]] \
      || fail "BaseOS repo is not configured on all hosts"
    [[ "$(echo "$repo_out" | grep -c '\[AppStream\]')" -eq 5 ]] \
      || fail "AppStream repo is not configured on all hosts"
    [[ "$(echo "$repo_out" | grep -c 'file:///mnt/BaseOS')" -eq 5 ]] \
      || fail "BaseOS baseurl is incorrect or missing on some hosts"
    [[ "$(echo "$repo_out" | grep -c 'file:///mnt/AppStream')" -eq 5 ]] \
      || fail "AppStream baseurl is incorrect or missing on some hosts"
    [[ "$(echo "$repo_out" | grep -ci 'gpgcheck\s*=\s*1')" -eq 10 ]] \
      || fail "gpgcheck is not enabled for both repos on all hosts"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
