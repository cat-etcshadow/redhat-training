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

grep -qE "ansible\.builtin\.lineinfile|lineinfile:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use lineinfile module"

grep -qE "ansible\.builtin\.replace|replace:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use replace module"

grep -q "$CONFIG_FILE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference CONFIG_FILE ($CONFIG_FILE)"

grep -q "notify" "$PLAYBOOK_FILE" \
  || fail "playbook does not notify a handler"

grep -q "restart sshd" "$PLAYBOOK_FILE" \
  || fail "handler 'restart sshd' not defined or referenced"

grep -qE "PermitEmptyPasswords" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference PermitEmptyPasswords"

[[ $errors -eq 0 ]] && exit 0 || exit 1
