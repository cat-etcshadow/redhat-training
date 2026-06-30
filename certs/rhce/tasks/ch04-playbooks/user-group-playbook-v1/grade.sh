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

grep -qE "ansible\.builtin\.group|^[[:space:]]*group:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the group module"

grep -qE "ansible\.builtin\.user|^[[:space:]]*user:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the user module"

grep -qE "ansible\.posix\.authorized_key|^[[:space:]]*authorized_key:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use authorized_key module"

grep -q "$GROUP_NAME" "$PLAYBOOK_FILE" \
  || fail "group name $GROUP_NAME not found in playbook"

grep -q "$GROUP_GID" "$PLAYBOOK_FILE" \
  || fail "GID $GROUP_GID not set in playbook"

grep -q "$USER_NAME" "$PLAYBOOK_FILE" \
  || fail "user name $USER_NAME not found in playbook"

grep -q "$USER_UID" "$PLAYBOOK_FILE" \
  || fail "UID $USER_UID not set in playbook"

grep -q "$USER_SHELL" "$PLAYBOOK_FILE" \
  || fail "shell $USER_SHELL not set for user"

[[ $errors -eq 0 ]] && exit 0 || exit 1
