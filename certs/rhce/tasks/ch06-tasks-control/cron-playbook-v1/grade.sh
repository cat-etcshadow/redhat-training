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

grep -q "cron" "$PLAYBOOK_FILE" \
  || fail "playbook does not use cron module"
grep -q "$CRON_USER" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference user $CRON_USER"
grep -q "logger" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference logger command"
grep -q "$CRON_MINUTE" "$PLAYBOOK_FILE" \
  || fail "playbook does not set minute=$CRON_MINUTE"
grep -qi "hosts:\s*all" "$PLAYBOOK_FILE" \
  || fail "playbook does not target all hosts"

[[ $errors -eq 0 ]] && exit 0 || exit 1
