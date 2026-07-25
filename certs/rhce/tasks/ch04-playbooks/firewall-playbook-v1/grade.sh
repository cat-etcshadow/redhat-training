#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "ansible\.posix\.firewalld|^[[:space:]]*firewalld:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the firewalld module"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    as_student "ansible webservers -i $INVENTORY_FILE -m command -a 'firewall-cmd --query-service=$FW_SERVICE'" &>/dev/null \
      || fail "$FW_SERVICE service is not enabled on all webservers hosts"
    as_student "ansible webservers -i $INVENTORY_FILE -m command -a 'firewall-cmd --permanent --query-service=$FW_SERVICE'" &>/dev/null \
      || fail "$FW_SERVICE service is not permanently enabled on all webservers hosts"
    as_student "ansible webservers -i $INVENTORY_FILE -m command -a 'firewall-cmd --query-port=${FW_PORT}/tcp'" &>/dev/null \
      || fail "port $FW_PORT/tcp is not enabled on all webservers hosts"
    as_student "ansible webservers -i $INVENTORY_FILE -m command -a 'firewall-cmd --permanent --query-port=${FW_PORT}/tcp'" &>/dev/null \
      || fail "port $FW_PORT/tcp is not permanently enabled on all webservers hosts"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
