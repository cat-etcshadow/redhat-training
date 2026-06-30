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

grep -qE "block:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a block: section"

grep -qE "rescue:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain a rescue: section"

grep -qE "always:" "$PLAYBOOK_FILE" \
  || fail "playbook does not contain an always: section"

grep -q "/tmp/deploy_status.txt" "$PLAYBOOK_FILE" \
  || fail "always section does not reference /tmp/deploy_status.txt"

grep -q "attempted" "$PLAYBOOK_FILE" \
  || fail "always section does not write content 'attempted'"

grep -q "httpd setup failed" "$PLAYBOOK_FILE" \
  || fail "rescue section missing 'httpd setup failed' message"

[[ $errors -eq 0 ]] && exit 0 || exit 1
