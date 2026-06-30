#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$MAIN_PLAYBOOK" ]] || fail "main playbook not found at $MAIN_PLAYBOOK"
[[ -f "$TASKS_FILE_INSTALL" ]] || fail "install tasks file not found at $TASKS_FILE_INSTALL"
[[ -f "$TASKS_FILE_CONFIG" ]] || fail "config tasks file not found at $TASKS_FILE_CONFIG"

python3 -c "import yaml,sys; yaml.safe_load(open('$MAIN_PLAYBOOK'))" 2>/dev/null \
  || fail "invalid YAML in $MAIN_PLAYBOOK"

python3 -c "import yaml,sys; yaml.safe_load(open('$TASKS_FILE_INSTALL'))" 2>/dev/null \
  || fail "invalid YAML in $TASKS_FILE_INSTALL"

python3 -c "import yaml,sys; yaml.safe_load(open('$TASKS_FILE_CONFIG'))" 2>/dev/null \
  || fail "invalid YAML in $TASKS_FILE_CONFIG"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$ANSIBLE_DIR/inventory" "$MAIN_PLAYBOOK" &>/dev/null \
  || fail "syntax check of main playbook failed"

grep -qE "include_tasks" "$MAIN_PLAYBOOK" \
  || fail "main playbook does not use include_tasks"

grep -qE "tasks/install\.yml" "$MAIN_PLAYBOOK" \
  || fail "main playbook does not include tasks/install.yml"

grep -qE "tasks/config\.yml" "$MAIN_PLAYBOOK" \
  || fail "main playbook does not include tasks/config.yml"

grep -qE "handlers:" "$MAIN_PLAYBOOK" \
  || fail "main playbook does not define handlers section"

grep -qE "restart httpd" "$MAIN_PLAYBOOK" \
  || fail "main playbook does not define 'restart httpd' handler"

grep -qE "dnf:" "$TASKS_FILE_INSTALL" \
  || fail "install.yml does not use dnf module"

grep -q "httpd" "$TASKS_FILE_INSTALL" \
  || fail "install.yml does not install httpd"

grep -q "notify" "$TASKS_FILE_CONFIG" \
  || fail "config.yml does not notify a handler"

grep -q "/etc/httpd/conf.d" "$TASKS_FILE_CONFIG" \
  || fail "config.yml does not reference /etc/httpd/conf.d"

[[ $errors -eq 0 ]] && exit 0 || exit 1
