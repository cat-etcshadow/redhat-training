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

grep -qE "^[[:space:]]*when:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use when: conditionals"

grep -q "ansible_distribution" "$PLAYBOOK_FILE" \
  || fail "playbook does not check ansible_distribution"

grep -q "ansible_os_family" "$PLAYBOOK_FILE" \
  || fail "playbook does not check ansible_os_family"

grep -q "ansible_memtotal_mb" "$PLAYBOOK_FILE" \
  || fail "playbook does not check ansible_memtotal_mb"

grep -q "$PACKAGE" "$PLAYBOOK_FILE" \
  || fail "package $PACKAGE not referenced in playbook"

grep -q "$STATUS_FILE" "$PLAYBOOK_FILE" \
  || fail "file $STATUS_FILE not referenced in playbook"

grep -q "Sufficient memory" "$PLAYBOOK_FILE" \
  || fail "debug message 'Sufficient memory available' not found"

[[ $errors -eq 0 ]] && exit 0 || exit 1
