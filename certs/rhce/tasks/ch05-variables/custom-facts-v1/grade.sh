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

grep -q "facts.d" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference /etc/ansible/facts.d/"
grep -q "custom.fact\|custom\.fact" "$PLAYBOOK_FILE" \
  || fail "playbook does not deploy custom.fact file"
grep -q "$FACT_PKG" "$PLAYBOOK_FILE" \
  || fail "playbook does not set web_package = $FACT_PKG"
grep -q "setup\|gather_facts" "$PLAYBOOK_FILE" \
  || fail "playbook does not re-gather facts after deploying custom.fact"
grep -q "ansible_local" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference ansible_local custom facts"
grep -q "debug" "$PLAYBOOK_FILE" \
  || fail "playbook does not use debug module to print the fact"

[[ $errors -eq 0 ]] && exit 0 || exit 1
