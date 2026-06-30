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

grep -qE "community\.general\.sefcontext|^[[:space:]]*sefcontext:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the sefcontext module"

grep -qE "ansible\.posix\.seboolean|^[[:space:]]*seboolean:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use the seboolean module"

grep -q "$CUSTOM_DIR" "$PLAYBOOK_FILE" \
  || fail "directory $CUSTOM_DIR not referenced in playbook"

grep -q "$SELINUX_TYPE" "$PLAYBOOK_FILE" \
  || fail "SELinux type $SELINUX_TYPE not set in playbook"

grep -q "$SELINUX_BOOLEAN" "$PLAYBOOK_FILE" \
  || fail "SELinux boolean $SELINUX_BOOLEAN not configured"

grep -q "persistent: yes" "$PLAYBOOK_FILE" \
  || fail "SELinux boolean not set to persistent"

grep -q "restorecon" "$PLAYBOOK_FILE" \
  || fail "restorecon not called to apply file context"

[[ $errors -eq 0 ]] && exit 0 || exit 1
