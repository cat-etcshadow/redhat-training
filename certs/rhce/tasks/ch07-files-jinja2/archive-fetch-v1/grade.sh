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

grep -qE "ansible\.builtin\.archive|archive:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use archive module"

grep -qE "ansible\.builtin\.fetch|fetch:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use fetch module"

grep -q "/etc/ssh" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference /etc/ssh as source"

grep -q "$ARCHIVE_NAME" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference ARCHIVE_NAME ($ARCHIVE_NAME)"

grep -q "$FETCH_DEST" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference FETCH_DEST ($FETCH_DEST)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
