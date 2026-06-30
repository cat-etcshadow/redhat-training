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

grep -qE "community\.general\.lvol|lvol:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use community.general.lvol"

grep -qE "ansible\.builtin\.mount|mount:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use ansible.builtin.mount"

grep -qE "state:\s*mounted" "$PLAYBOOK_FILE" \
  || fail "mount module does not use state: mounted (required for persistent mount)"

grep -q "$LV_SIZE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference LV_SIZE ($LV_SIZE)"

grep -q "$FS_TYPE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference FS_TYPE ($FS_TYPE)"

grep -q "$MOUNT_POINT" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference MOUNT_POINT ($MOUNT_POINT)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
