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

grep -q "ansible_facts\|ansible_memtotal_mb\|ansible_hostname\|ansible_bios_version\|inventory_hostname" \
  "$PLAYBOOK_FILE" || fail "playbook does not reference ansible facts"
grep -q "INVENTORY_HOSTNAME" "$PLAYBOOK_FILE" \
  || fail "playbook does not write INVENTORY_HOSTNAME to report"
grep -q "TOTAL_MEMORY_IN_MB" "$PLAYBOOK_FILE" \
  || fail "playbook does not write TOTAL_MEMORY_IN_MB to report"
grep -q "BIOS_VERSION" "$PLAYBOOK_FILE" \
  || fail "playbook does not write BIOS_VERSION to report"
grep -qi "copy" "$PLAYBOOK_FILE" \
  || fail "playbook does not use copy module to write the report file"
grep -q "hosts:\s*all" "$PLAYBOOK_FILE" \
  || fail "playbook does not target all hosts"

[[ $errors -eq 0 ]] && exit 0 || exit 1
