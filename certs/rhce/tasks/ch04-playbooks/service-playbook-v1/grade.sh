#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }
as_student() { su - student -c "$1"; }
INVENTORY_FILE="$ANSIBLE_DIR/inventory"

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "dnf" "$PLAYBOOK_FILE" || fail "playbook does not use ansible.builtin.dnf"
grep -qE "ansible\.posix\.firewalld|firewalld:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use ansible.posix.firewalld"
grep -qE "become:\s*(true|yes)" "$PLAYBOOK_FILE" || fail "playbook missing become: true"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    as_student "ansible all -i $INVENTORY_FILE -m command -a 'rpm -q $SERVICE_NAME'" &>/dev/null \
      || fail "$SERVICE_NAME is not installed on all hosts"
    as_student "ansible all -i $INVENTORY_FILE -m command -a 'systemctl is-active $SERVICE_NAME'" &>/dev/null \
      || fail "$SERVICE_NAME is not active on all hosts"
    as_student "ansible all -i $INVENTORY_FILE -m command -a 'systemctl is-enabled $SERVICE_NAME'" &>/dev/null \
      || fail "$SERVICE_NAME is not enabled on all hosts"
    as_student "ansible all -i $INVENTORY_FILE -m command -a 'firewall-cmd --query-service=$FIREWALL_SERVICE'" &>/dev/null \
      || fail "$FIREWALL_SERVICE is not enabled in the firewall on all hosts"
    as_student "ansible all -i $INVENTORY_FILE -m command -a 'firewall-cmd --permanent --query-service=$FIREWALL_SERVICE'" &>/dev/null \
      || fail "$FIREWALL_SERVICE is not permanently enabled in the firewall on all hosts"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
