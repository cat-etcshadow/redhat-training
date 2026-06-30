#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook $PLAYBOOK_FILE does not exist"
python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "ansible-playbook --syntax-check failed"

grep -q "timesync" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference timesync role"
grep -q "timesync_ntp_servers\|ntp_servers" "$PLAYBOOK_FILE" \
  || fail "playbook does not set timesync_ntp_servers variable"
grep -q "$NTP_SERVER" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference NTP server $NTP_SERVER"
grep -q "iburst" "$PLAYBOOK_FILE" \
  || fail "playbook does not set iburst parameter"
grep -qi "hosts:\s*all" "$PLAYBOOK_FILE" \
  || fail "playbook does not target all hosts"

[[ $errors -eq 0 ]] && exit 0 || exit 1
