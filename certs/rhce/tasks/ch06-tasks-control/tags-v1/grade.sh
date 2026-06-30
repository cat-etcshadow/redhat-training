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

grep -qE "tags:" "$PLAYBOOK_FILE" \
  || fail "playbook does not define any tags"

grep -q "packages" "$PLAYBOOK_FILE" \
  || fail "playbook missing tag 'packages'"

grep -q "config" "$PLAYBOOK_FILE" \
  || fail "playbook missing tag 'config'"

grep -q "service" "$PLAYBOOK_FILE" \
  || fail "playbook missing tag 'service'"

grep -q "always" "$PLAYBOOK_FILE" \
  || fail "playbook missing 'always' tag on at least one task"

grep -q "vim-enhanced" "$PLAYBOOK_FILE" \
  || fail "playbook does not install vim-enhanced"

grep -q "/etc/myapp.conf" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference /etc/myapp.conf"

[[ $errors -eq 0 ]] && exit 0 || exit 1
