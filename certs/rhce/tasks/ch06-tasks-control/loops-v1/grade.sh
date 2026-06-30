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

grep -qE "^[[:space:]]*loop:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the loop: keyword"

grep -qE "ansible\.builtin\.dnf|^[[:space:]]*dnf:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the dnf module"

grep -qE "ansible\.builtin\.user|^[[:space:]]*user:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the user module"

grep -q "$PKG1" "$PLAYBOOK_FILE" || fail "package $PKG1 not found in playbook"
grep -q "$PKG2" "$PLAYBOOK_FILE" || fail "package $PKG2 not found in playbook"
grep -q "$PKG3" "$PLAYBOOK_FILE" || fail "package $PKG3 not found in playbook"

grep -q "$USER1" "$PLAYBOOK_FILE" || fail "user $USER1 not found in playbook"
grep -q "$USER2" "$PLAYBOOK_FILE" || fail "user $USER2 not found in playbook"
grep -q "$USER3" "$PLAYBOOK_FILE" || fail "user $USER3 not found in playbook"

grep -q "with_items" "$PLAYBOOK_FILE" \
  && fail "use loop: keyword, not with_items"

[[ $errors -eq 0 ]] && exit 0 || exit 1
