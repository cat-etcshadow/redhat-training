#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "community\.general\.nmcli|^[[:space:]]*nmcli:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the nmcli module"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    conn_out=$(as_student "ansible dev -i $INVENTORY_FILE -m command -a 'nmcli -g connection.interface-name,ipv4.method,ipv4.addresses,ipv4.gateway,ipv4.dns connection show $CONN_NAME'" 2>&1)
    if [[ $? -ne 0 ]]; then
      fail "connection profile $CONN_NAME does not exist on dev"
    else
      echo "$conn_out" | grep -q "$DEVICE"     || fail "connection $CONN_NAME is not bound to device $DEVICE"
      echo "$conn_out" | grep -qi "manual"     || fail "connection $CONN_NAME ipv4.method is not manual"
      echo "$conn_out" | grep -q "${IP_ADDRESS%%/*}" || fail "connection $CONN_NAME does not have IP $IP_ADDRESS"
      echo "$conn_out" | grep -q "$GATEWAY"    || fail "connection $CONN_NAME does not have gateway $GATEWAY"
      echo "$conn_out" | grep -q "$DNS_SERVER" || fail "connection $CONN_NAME does not have DNS server $DNS_SERVER"
    fi
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
