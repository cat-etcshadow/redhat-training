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

grep -q "php"      "$PLAYBOOK_FILE" || fail "playbook does not reference 'php' package"
grep -q "mariadb"  "$PLAYBOOK_FILE" || fail "playbook does not reference 'mariadb' package"
grep -q "RPM Development Tools\|\"RPM Development Tools\"" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference 'RPM Development Tools' group"
grep -q "state:\s*latest\|name:\s*\*\|upgrade" "$PLAYBOOK_FILE" \
  || fail "playbook does not update all packages to latest (state: latest or name: '*')"
grep -q "dnf" "$PLAYBOOK_FILE" \
  || fail "playbook must use ansible.builtin.dnf (not yum)"
grep -q "become:\s*true\|become:\s*yes" "$PLAYBOOK_FILE" \
  || fail "playbook missing become: true"

[[ $errors -eq 0 ]] && exit 0 || exit 1
