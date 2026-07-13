#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }
as_student() { su - student -c "$1"; }
INVENTORY_FILE="$ANSIBLE_DIR/inventory"

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook not found at $PLAYBOOK_FILE"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "syntax check failed"

grep -qE "become:\s*(true|yes)" "$PLAYBOOK_FILE" || fail "playbook missing become: true"
grep -qE "state:\s*latest" "$PLAYBOOK_FILE" \
  || fail "playbook does not install any packages at latest version"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    as_student "ansible webservers -i $INVENTORY_FILE -m command -a 'rpm -q $PKG1'" &>/dev/null \
      || fail "$PKG1 is not installed on all webservers hosts"
    as_student "ansible webservers -i $INVENTORY_FILE -m command -a 'rpm -q $PKG2'" &>/dev/null \
      || fail "$PKG2 is not installed on all webservers hosts"
    as_student "ansible dev -i $INVENTORY_FILE -m command -a 'rpm -q $PKG3'" &>/dev/null \
      || fail "$PKG3 is not installed on dev"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
