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

# template checks
grep -q "for\|groups\['all'\]\|groups.all" "$TEMPLATE_FILE" \
  || fail "template does not loop over all hosts"
grep -q "127.0.0.1" "$TEMPLATE_FILE" \
  || fail "template missing localhost line"
grep -q "ansible_facts\|hostvars\|default_ipv4\|ansible_default_ipv4" "$TEMPLATE_FILE" \
  || fail "template does not use host IP facts"

# playbook checks
grep -q "template" "$PLAYBOOK_FILE" \
  || fail "playbook does not use template module"
grep -q "$OUTPUT_FILE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference output file $OUTPUT_FILE"
grep -q "hosts.j2\|$TEMPLATE_FILE" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference the template file"

[[ $errors -eq 0 ]] && exit 0 || exit 1
