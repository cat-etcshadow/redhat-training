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

grep -qE "ansible\.builtin\.blockinfile|^[[:space:]]*blockinfile:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use blockinfile module"

grep -q "$TARGET_FILE" "$PLAYBOOK_FILE" \
  || fail "target file $TARGET_FILE not referenced"

grep -q "$BLOCK_CONTENT" "$PLAYBOOK_FILE" \
  || fail "block content not found in playbook"

grep -q "$MARKER" "$PLAYBOOK_FILE" \
  || fail "marker '$MARKER' not found in playbook"

grep -q "{mark}" "$PLAYBOOK_FILE" \
  || fail "marker does not include {mark} placeholder"

grep -q "create: true" "$PLAYBOOK_FILE" \
  || fail "create: true not set (file may not exist on target)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
