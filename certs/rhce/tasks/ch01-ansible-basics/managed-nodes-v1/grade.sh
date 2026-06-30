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

grep -qE "ansible\.builtin\.user|^[[:space:]]*user:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the user module"

grep -qE "ansible\.posix\.authorized_key|^[[:space:]]*authorized_key:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use authorized_key module"

grep -q "$ANSIBLE_USER" "$PLAYBOOK_FILE" \
  || fail "user $ANSIBLE_USER not referenced in playbook"

grep -q "NOPASSWD" "$PLAYBOOK_FILE" \
  || fail "sudoers NOPASSWD rule not found"

grep -q "/etc/sudoers.d" "$PLAYBOOK_FILE" \
  || fail "/etc/sudoers.d not referenced in playbook"

grep -q "0440" "$PLAYBOOK_FILE" \
  || fail "sudoers file mode 0440 not set"

[[ $errors -eq 0 ]] && exit 0 || exit 1
