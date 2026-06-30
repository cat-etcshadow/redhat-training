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

grep -q "yum_repository\|ansible.builtin.yum_repository" "$PLAYBOOK_FILE" \
  || fail "playbook does not use yum_repository module"
grep -q "BaseOS" "$PLAYBOOK_FILE" \
  || fail "playbook does not configure BaseOS repository"
grep -q "AppStream" "$PLAYBOOK_FILE" \
  || fail "playbook does not configure AppStream repository"
grep -q "file:///mnt/BaseOS" "$PLAYBOOK_FILE" \
  || fail "BaseOS baseurl is incorrect or missing"
grep -q "file:///mnt/AppStream" "$PLAYBOOK_FILE" \
  || fail "AppStream baseurl is incorrect or missing"
grep -q "gpgcheck" "$PLAYBOOK_FILE" \
  || fail "playbook does not set gpgcheck"
grep -qi "hosts:\s*all" "$PLAYBOOK_FILE" \
  || fail "playbook does not target all hosts"

[[ $errors -eq 0 ]] && exit 0 || exit 1
