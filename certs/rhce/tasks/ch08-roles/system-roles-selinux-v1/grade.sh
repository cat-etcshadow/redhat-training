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

grep -qE "rhel_system_roles\.selinux|selinux" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference selinux role"

grep -qE "selinux_state\s*:\s*$SELINUX_MODE" "$PLAYBOOK_FILE" \
  || fail "selinux_state not set to $SELINUX_MODE"

grep -qE "selinux_reboot_ok\s*:\s*(true|yes)" "$PLAYBOOK_FILE" \
  || fail "selinux_reboot_ok not set to true"

[[ $errors -eq 0 ]] && exit 0 || exit 1
