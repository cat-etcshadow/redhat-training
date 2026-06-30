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

grep -qE "ansible\.builtin\.copy|copy:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use copy module"

grep -q "/etc/motd" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference /etc/motd"

[[ -f "$ANSIBLE_DIR/check-mode.sh" ]] \
  || fail "check-mode.sh not found at $ANSIBLE_DIR/check-mode.sh"

grep -q "\-\-check" "$ANSIBLE_DIR/check-mode.sh" \
  || fail "check-mode.sh does not use --check flag"

grep -q "\-\-diff" "$ANSIBLE_DIR/check-mode.sh" \
  || fail "check-mode.sh does not use --diff flag"

[[ -x "$ANSIBLE_DIR/check-mode.sh" ]] \
  || fail "check-mode.sh is not executable"

[[ $errors -eq 0 ]] && exit 0 || exit 1
