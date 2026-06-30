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

# check bug 1 fixed: correct group_names membership test
grep -qE "'dev' in group_names" "$PLAYBOOK_FILE" \
  || fail "Bug 1 not fixed: 'dev' in group_names not found (was: group_names == 'dev')"

# check bug 1 old form gone
grep -qE "group_names == 'dev'" "$PLAYBOOK_FILE" \
  && fail "Bug 1 still present: group_names == 'dev' found"

# check bug 2 fixed: item.name not just item
grep -qE "item\.name" "$PLAYBOOK_FILE" \
  || fail "Bug 2 not fixed: item.name not found"

# check bug 3 fixed: result.stdout not result.output
grep -qE "result\.stdout" "$PLAYBOOK_FILE" \
  || fail "Bug 3 not fixed: result.stdout not found (was: result.output)"

grep -qE "result\.output" "$PLAYBOOK_FILE" \
  && fail "Bug 3 still present: result.output still found"

[[ $errors -eq 0 ]] && exit 0 || exit 1
