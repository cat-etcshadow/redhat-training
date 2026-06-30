#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook $PLAYBOOK_FILE does not exist"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "playbook still has invalid YAML"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "ansible-playbook --syntax-check still fails"

grep -q "httpd"   "$PLAYBOOK_FILE" || fail "httpd reference removed from playbook"
grep -q "notify"  "$PLAYBOOK_FILE" || fail "notify removed from playbook"
grep -q "restart httpd" "$PLAYBOOK_FILE" || fail "handler name changed or removed"
grep -qi "hosts:\s*all" "$PLAYBOOK_FILE" || fail "hosts: all removed from playbook"

[[ $errors -eq 0 ]] && exit 0 || exit 1
