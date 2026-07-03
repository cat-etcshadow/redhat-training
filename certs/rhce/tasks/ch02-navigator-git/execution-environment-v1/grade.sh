#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

su - student -c "podman image exists $EE_IMAGE" \
  || fail "Execution Environment image $EE_IMAGE has not been pulled"

[[ -f "$NAVIGATOR_CFG" ]] || fail "ansible-navigator.yml not found at $NAVIGATOR_CFG"

python3 -c "import yaml,sys; yaml.safe_load(open('$NAVIGATOR_CFG'))" 2>/dev/null \
  || fail "invalid YAML in $NAVIGATOR_CFG"

grep -qE "enabled:\s*true" "$NAVIGATOR_CFG" \
  || fail "execution-environment.enabled must be set to true"

grep -q "$EE_IMAGE" "$NAVIGATOR_CFG" \
  || fail "navigator config does not reference the image $EE_IMAGE"

su - student -c "cd $ANSIBLE_DIR && ANSIBLE_NAVIGATOR_CONFIG=$NAVIGATOR_CFG ansible-navigator run $PLAYBOOK_FILE -m stdout" \
  &>/tmp/nav-ee-out.log \
  || fail "ansible-navigator run did not complete successfully (see /tmp/nav-ee-out.log)"

grep -q "ee run OK" /tmp/nav-ee-out.log \
  || fail "expected playbook output not found — navigator run may not have used the EE config"

[[ $errors -eq 0 ]] && exit 0 || exit 1
