#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$REQUIREMENTS_FILE" ]] \
  || fail "requirements.yml not found at $REQUIREMENTS_FILE"

python3 -c "import yaml,sys; yaml.safe_load(open('$REQUIREMENTS_FILE'))" 2>/dev/null \
  || fail "invalid YAML in requirements.yml"

# must reference both roles by name
grep -q "apache" "$REQUIREMENTS_FILE" || fail "requirements.yml does not include apache role"
grep -q "mysql"  "$REQUIREMENTS_FILE" || fail "requirements.yml does not include mysql role"

# name: aliases must be set
grep -q "name:" "$REQUIREMENTS_FILE" \
  || fail "requirements.yml does not set role name aliases (name: field)"

# roles must be installed
[[ -d "$ROLES_DIR/apache" ]] \
  || fail "roles/apache directory not found — run: ansible-galaxy install -r roles/requirements.yml -p roles/"
[[ -d "$ROLES_DIR/mysql" ]] \
  || fail "roles/mysql directory not found — run: ansible-galaxy install -r roles/requirements.yml -p roles/"

[[ $errors -eq 0 ]] && exit 0 || exit 1
