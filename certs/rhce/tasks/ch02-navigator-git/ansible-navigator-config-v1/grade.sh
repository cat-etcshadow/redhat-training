#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -f "$NAVIGATOR_CFG" ]] || fail "ansible-navigator.yml not found at $NAVIGATOR_CFG"

python3 -c "import yaml,sys; yaml.safe_load(open('$NAVIGATOR_CFG'))" 2>/dev/null \
  || fail "invalid YAML in $NAVIGATOR_CFG"

grep -q "ansible-navigator:" "$NAVIGATOR_CFG" \
  || fail "missing top-level ansible-navigator: key"

grep -qE "enabled:\s*false" "$NAVIGATOR_CFG" \
  || fail "execution-environment.enabled must be set to false"

grep -q "$INVENTORY_FILE" "$NAVIGATOR_CFG" \
  || fail "navigator config does not reference the inventory at $INVENTORY_FILE"

su - student -c "cd $ANSIBLE_DIR && ANSIBLE_NAVIGATOR_CONFIG=$NAVIGATOR_CFG ansible-navigator run $PLAYBOOK_FILE -m stdout" \
  &>/tmp/nav-config-out.log \
  || fail "ansible-navigator run did not complete successfully (see /tmp/nav-config-out.log)"

grep -q "navigator run OK" /tmp/nav-config-out.log \
  || fail "expected playbook output not found — navigator run may not have used the candidate's config"

[[ $errors -eq 0 ]] && exit 0 || exit 1
