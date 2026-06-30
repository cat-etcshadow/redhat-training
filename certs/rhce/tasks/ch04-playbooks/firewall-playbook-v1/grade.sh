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

grep -qE "ansible\.posix\.firewalld|^[[:space:]]*firewalld:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the firewalld module"

grep -q "$FW_SERVICE" "$PLAYBOOK_FILE" \
  || fail "service $FW_SERVICE not found in playbook"

grep -q "$FW_PORT" "$PLAYBOOK_FILE" \
  || fail "port $FW_PORT not found in playbook"

grep -q "permanent: true" "$PLAYBOOK_FILE" \
  || fail "permanent: true not set"

grep -q "immediate: true" "$PLAYBOOK_FILE" \
  || fail "immediate: true not set"

[[ $errors -eq 0 ]] && exit 0 || exit 1
