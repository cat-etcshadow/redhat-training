#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

ROLE_DIR="$ROLES_DIR/$ROLE_NAME"

[[ -d "$ROLE_DIR" ]] \
  || fail "role directory $ROLE_DIR does not exist"
[[ -f "$ROLE_DIR/tasks/main.yml" ]] \
  || fail "tasks/main.yml missing in role"
[[ -f "$ROLE_DIR/handlers/main.yml" ]] \
  || fail "handlers/main.yml missing in role"
[[ -f "$ROLE_DIR/templates/index.html.j2" ]] \
  || fail "templates/index.html.j2 missing in role"
[[ -f "$PLAYBOOK_FILE" ]] \
  || fail "playbook $PLAYBOOK_FILE does not exist"

python3 -c "import yaml,sys; yaml.safe_load(open('$ROLE_DIR/tasks/main.yml'))" 2>/dev/null \
  || fail "invalid YAML in tasks/main.yml"
python3 -c "import yaml,sys; yaml.safe_load(open('$ROLE_DIR/handlers/main.yml'))" 2>/dev/null \
  || fail "invalid YAML in handlers/main.yml"
python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in playbook"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "ansible-playbook --syntax-check failed"

grep -q "httpd" "$ROLE_DIR/tasks/main.yml" \
  || fail "tasks/main.yml does not reference httpd"
grep -q "firewalld\|ansible.posix.firewalld" "$ROLE_DIR/tasks/main.yml" \
  || fail "tasks/main.yml does not configure firewall"
grep -q "template\|ansible.builtin.template" "$ROLE_DIR/tasks/main.yml" \
  || fail "tasks/main.yml does not deploy template"
grep -q "notify" "$ROLE_DIR/tasks/main.yml" \
  || fail "tasks/main.yml does not use notify"
grep -q "restart httpd" "$ROLE_DIR/handlers/main.yml" \
  || fail "handlers/main.yml missing 'restart httpd' handler"
grep -q "fqdn\|default_ipv4\|ansible_facts" "$ROLE_DIR/templates/index.html.j2" \
  || fail "index.html.j2 does not use host facts"
grep -q "webservers\|$ROLE_NAME" "$PLAYBOOK_FILE" \
  || fail "playbook does not apply $ROLE_NAME role to webservers"

[[ $errors -eq 0 ]] && exit 0 || exit 1
