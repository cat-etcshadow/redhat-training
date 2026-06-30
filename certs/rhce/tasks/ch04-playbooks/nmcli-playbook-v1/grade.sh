#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook not found at $PLAYBOOK_FILE"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "syntax check failed"

grep -qE "community\.general\.nmcli|^[[:space:]]*nmcli:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the nmcli module"

grep -q "$CONN_NAME" "$PLAYBOOK_FILE" \
  || fail "connection name $CONN_NAME not found"

grep -q "$DEVICE" "$PLAYBOOK_FILE" \
  || fail "device $DEVICE not found"

grep -q "$IP_ADDRESS" "$PLAYBOOK_FILE" \
  || fail "IP address $IP_ADDRESS not found"

grep -q "$GATEWAY" "$PLAYBOOK_FILE" \
  || fail "gateway $GATEWAY not found"

grep -q "$DNS_SERVER" "$PLAYBOOK_FILE" \
  || fail "DNS server $DNS_SERVER not found"

grep -q "manual" "$PLAYBOOK_FILE" \
  || fail "IPv4 method 'manual' not set"

[[ $errors -eq 0 ]] && exit 0 || exit 1
