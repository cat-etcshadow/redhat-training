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

grep -q "debug"             "$PLAYBOOK_FILE" || fail "playbook does not use debug module"
grep -q "inventory_hostname" "$PLAYBOOK_FILE" || fail "playbook does not print inventory_hostname"
grep -q "os_family"         "$PLAYBOOK_FILE" || fail "playbook does not print os_family"
grep -q "memtotal_mb"       "$PLAYBOOK_FILE" || fail "playbook does not print memtotal_mb"
grep -q "register"          "$PLAYBOOK_FILE" || fail "playbook does not register a variable"
grep -q "uptime_result\|uptime" "$PLAYBOOK_FILE" \
  || fail "playbook does not register uptime command output"
grep -q "stdout"            "$PLAYBOOK_FILE" || fail "playbook does not print .stdout of registered var"

[[ $errors -eq 0 ]] && exit 0 || exit 1
