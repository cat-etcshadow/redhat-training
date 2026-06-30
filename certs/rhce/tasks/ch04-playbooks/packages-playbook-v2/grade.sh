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

grep -q "$PKG1" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference PKG1 ($PKG1)"

grep -q "$PKG2" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference PKG2 ($PKG2)"

grep -q "$PKG3" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference PKG3 ($PKG3)"

grep -qE "state:\s*latest" "$PLAYBOOK_FILE" \
  || fail "playbook does not install packages at latest version"

grep -qE "become:\s*(true|yes)" "$PLAYBOOK_FILE" \
  || fail "playbook missing become: true"

grep -qE "hosts:\s*(webservers|dev|test)" "$PLAYBOOK_FILE" \
  || fail "playbook does not target expected host groups"

[[ $errors -eq 0 ]] && exit 0 || exit 1
