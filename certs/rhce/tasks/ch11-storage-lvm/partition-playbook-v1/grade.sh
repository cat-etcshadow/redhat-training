#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook not found at $PLAYBOOK_FILE"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$ANSIBLE_DIR/inventory" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "syntax check failed"

grep -qE "community\.general\.parted|parted:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use community.general.parted"

grep -qE "ansible\.builtin\.filesystem|filesystem:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use filesystem module"

grep -qE "block:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a block: section"

grep -qE "rescue:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a rescue: section"

grep -q "Could not create partition of that size" "$PLAYBOOK_FILE" \
  || fail "rescue section missing 'Could not create partition of that size' message"

grep -q "this disk does not exist" "$PLAYBOOK_FILE" \
  || fail "playbook missing 'this disk does not exist' message"

grep -q "$FS_TYPE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference FS_TYPE ($FS_TYPE)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
