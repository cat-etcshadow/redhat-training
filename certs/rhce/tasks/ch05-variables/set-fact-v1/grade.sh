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

grep -qE "set_fact:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use set_fact"

grep -qE "group_names" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference group_names magic variable"

grep -qE "groups\['prod'\]|groups\.prod" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference groups['prod'] or groups.prod"

grep -qE "debug:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use debug module to print variables"

grep -qE "server_role" "$PLAYBOOK_FILE" \
  || fail "playbook does not define or use server_role variable"

[[ $errors -eq 0 ]] && exit 0 || exit 1
