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

grep -qE "dnf" "$PLAYBOOK_FILE" \
  || fail "playbook does not use ansible.builtin.dnf"

grep -q "$SERVICE_NAME" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference SERVICE_NAME ($SERVICE_NAME)"

grep -qE "enabled:\s*(true|yes)" "$PLAYBOOK_FILE" \
  || fail "service not set to enabled: true"

grep -qE "state:\s*started" "$PLAYBOOK_FILE" \
  || fail "service state: started not found"

grep -qE "ansible\.posix\.firewalld|firewalld:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use ansible.posix.firewalld"

grep -q "$FIREWALL_SERVICE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference FIREWALL_SERVICE ($FIREWALL_SERVICE)"

grep -qE "become:\s*(true|yes)" "$PLAYBOOK_FILE" \
  || fail "playbook missing become: true"

[[ $errors -eq 0 ]] && exit 0 || exit 1
