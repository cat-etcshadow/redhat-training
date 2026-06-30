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

grep -qE "register:\s*svc_result" "$PLAYBOOK_FILE" \
  || fail "playbook does not register result as svc_result"

grep -q "svc_result" "$PLAYBOOK_FILE" \
  || fail "svc_result not referenced in playbook"

grep -qE "when:" "$PLAYBOOK_FILE" \
  || fail "playbook does not use when: conditional"

grep -qE "svc_result\.rc" "$PLAYBOOK_FILE" \
  || fail "when condition does not reference svc_result.rc"

grep -q "$CHECK_SERVICE" "$PLAYBOOK_FILE" \
  || fail "CHECK_SERVICE ($CHECK_SERVICE) not referenced in playbook"

grep -qE "uptime_seconds" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference ansible_facts uptime_seconds"

[[ $errors -eq 0 ]] && exit 0 || exit 1
