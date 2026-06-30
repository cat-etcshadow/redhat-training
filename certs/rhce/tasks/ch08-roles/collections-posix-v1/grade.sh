#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$ANSIBLE_DIR/ansible.cfg" ]] || fail "ansible.cfg not found"

grep -qE "collections_paths\s*=\s*.*$COLLECTIONS_DIR" "$ANSIBLE_DIR/ansible.cfg" \
  || fail "ansible.cfg does not set collections_paths to $COLLECTIONS_DIR"

# check collection is installed — either as namespace/collection dir or ansible_collections subdir
[[ -d "$COLLECTIONS_DIR/ansible_collections/ansible/posix" ]] \
  || [[ -d "$COLLECTIONS_DIR/ansible/posix" ]] \
  || fail "ansible.posix collection not found under $COLLECTIONS_DIR"

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook not found at $PLAYBOOK_FILE"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$ANSIBLE_DIR/inventory" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "syntax check failed"

grep -qE "ansible\.posix\.sysctl" "$PLAYBOOK_FILE" \
  || fail "playbook does not use ansible.posix.sysctl"

grep -qE "vm\.swappiness" "$PLAYBOOK_FILE" \
  || fail "playbook does not set vm.swappiness"

[[ $errors -eq 0 ]] && exit 0 || exit 1
