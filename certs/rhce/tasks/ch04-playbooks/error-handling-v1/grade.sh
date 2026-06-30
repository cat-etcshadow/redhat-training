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

grep -qE "block:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a block: section"

grep -qE "rescue:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a rescue: section"

grep -qE "always:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain an always: section"

grep -qE "community\.general\.lvol|lvol:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use community.general.lvol"

grep -q "could not create logical volume of that size" "$PLAYBOOK_FILE" \
  || fail "rescue section missing error message 'could not create logical volume of that size'"

grep -q "LVM task complete" "$PLAYBOOK_FILE" \
  || fail "always section missing 'LVM task complete' message"

grep -q "$LV_SIZE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference LV_SIZE ($LV_SIZE)"

grep -q "$FALLBACK_SIZE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference FALLBACK_SIZE ($FALLBACK_SIZE)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
