#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook $PLAYBOOK_FILE does not exist"
[[ -f "$TEMPLATE_FILE" ]] || fail "template $TEMPLATE_FILE does not exist"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "ansible-playbook --syntax-check failed"

# group_vars checks
GV="$ANSIBLE_DIR/group_vars"
[[ -d "$GV" ]] || fail "group_vars/ directory not found"
[[ -f "$GV/dev.yml" || -f "$GV/dev/main.yml" ]] || fail "group_vars/dev.yml missing"
[[ -f "$GV/test.yml" || -f "$GV/test/main.yml" ]] || fail "group_vars/test.yml missing"
[[ -f "$GV/prod.yml" || -f "$GV/prod/main.yml" ]] || fail "group_vars/prod.yml missing"

grep -qi "motd_message" "$GV/dev.yml"  2>/dev/null || fail "dev group_vars missing motd_message"
grep -qi "motd_message" "$GV/test.yml" 2>/dev/null || fail "test group_vars missing motd_message"
grep -qi "motd_message" "$GV/prod.yml" 2>/dev/null || fail "prod group_vars missing motd_message"

# template checks
grep -q "motd_message" "$TEMPLATE_FILE" \
  || fail "template does not reference motd_message variable"
grep -q "ansible_facts\|ansible_hostname\|hostname" "$TEMPLATE_FILE" \
  || fail "template does not reference hostname fact"

# playbook checks
grep -q "template" "$PLAYBOOK_FILE" \
  || fail "playbook does not use template module"
grep -q "/etc/motd" "$PLAYBOOK_FILE" \
  || fail "playbook does not deploy to /etc/motd"

[[ $errors -eq 0 ]] && exit 0 || exit 1
