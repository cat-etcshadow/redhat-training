#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d "$ROLES_DIR/$ROLE_NAME" ]] \
  || fail "role directory not found at $ROLES_DIR/$ROLE_NAME"

[[ -f "$ROLES_DIR/$ROLE_NAME/defaults/main.yml" ]] \
  || fail "role defaults/main.yml not found"

[[ -f "$ROLES_DIR/$ROLE_NAME/tasks/main.yml" ]] \
  || fail "role tasks/main.yml not found"

grep -qE "web_port\s*:\s*80" "$ROLES_DIR/$ROLE_NAME/defaults/main.yml" \
  || fail "role defaults/main.yml does not set web_port: 80"

grep -qE "web_user\s*:\s*apache" "$ROLES_DIR/$ROLE_NAME/defaults/main.yml" \
  || fail "role defaults/main.yml does not set web_user: apache"

grep -qE "web_port|web_user" "$ROLES_DIR/$ROLE_NAME/tasks/main.yml" \
  || fail "role tasks/main.yml does not reference web_port or web_user variables"

[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook not found at $PLAYBOOK_FILE"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$ANSIBLE_DIR/inventory" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "syntax check failed"

grep -q "$ROLE_NAME" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference role $ROLE_NAME"

grep -qE "web_port\s*:\s*8080" "$PLAYBOOK_FILE" \
  || fail "playbook does not override web_port to 8080"

[[ $errors -eq 0 ]] && exit 0 || exit 1
