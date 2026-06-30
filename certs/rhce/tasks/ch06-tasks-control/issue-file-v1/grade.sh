#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook $PLAYBOOK_FILE does not exist"
python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "ansible-playbook --syntax-check failed"

grep -q "/etc/issue" "$PLAYBOOK_FILE" \
  || fail "playbook does not write to /etc/issue"
grep -q "when:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use when: conditions"
grep -q "group_names" "$PLAYBOOK_FILE" \
  || fail "playbook does not use group_names variable"
grep -q "$DEV_MSG"  "$PLAYBOOK_FILE" || fail "playbook missing dev message '$DEV_MSG'"
grep -q "$TEST_MSG" "$PLAYBOOK_FILE" || fail "playbook missing test message '$TEST_MSG'"
grep -q "$PROD_MSG" "$PLAYBOOK_FILE" || fail "playbook missing prod message '$PROD_MSG'"
grep -q "copy" "$PLAYBOOK_FILE" \
  || fail "playbook does not use copy module"

[[ $errors -eq 0 ]] && exit 0 || exit 1
