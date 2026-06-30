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

grep -qE "become:\s*(true|yes)" "$PLAYBOOK_FILE" \
  || fail "playbook does not use become: true"

grep -qE "become_user:\s*$TARGET_USER" "$PLAYBOOK_FILE" \
  || fail "playbook does not use become_user: $TARGET_USER"

grep -q "$TARGET_USER" "$PLAYBOOK_FILE" \
  || fail "TARGET_USER ($TARGET_USER) not referenced in playbook"

grep -qE "ansible\.builtin\.user|user:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use user module to create account"

[[ $errors -eq 0 ]] && exit 0 || exit 1
