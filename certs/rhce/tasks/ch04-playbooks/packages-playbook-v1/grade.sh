#!/usr/bin/env bash
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }
as_student() { su - student -c "$1"; }

[[ -f "$PLAYBOOK_FILE" ]] || { fail "playbook $PLAYBOOK_FILE does not exist"; exit 1; }

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE --syntax-check" &>/dev/null \
  || fail "ansible-playbook --syntax-check failed"

grep -q "dnf" "$PLAYBOOK_FILE" || fail "playbook must use ansible.builtin.dnf (not yum)"
grep -Eq "become:[[:space:]]*(true|yes)" "$PLAYBOOK_FILE" || fail "playbook missing become: true"
grep -Eq 'state:\s*latest|name:\s*"?\*"?' "$PLAYBOOK_FILE" \
  || fail "playbook does not update all packages to latest (state: latest with name: '*')"

if [[ $errors -eq 0 ]]; then
  run_out=$(as_student "cd $ANSIBLE_DIR && ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE" 2>&1)
  if [[ $? -ne 0 ]]; then
    fail "ansible-playbook run failed"
    echo "$run_out" | tail -30
  else
    as_student "ansible dev,test,prod -i $INVENTORY_FILE -m command -a 'rpm -q php'" &>/dev/null \
      || fail "php is not installed on all of dev/test/prod"
    as_student "ansible dev,test,prod -i $INVENTORY_FILE -m command -a 'rpm -q mariadb'" &>/dev/null \
      || fail "mariadb is not installed on all of dev/test/prod"

    group_out=$(as_student "ansible dev -i $INVENTORY_FILE -m command -a 'dnf group list installed'" 2>&1)
    echo "$group_out" | grep -qi "Development Tools" \
      || fail "'RPM Development Tools' group is not installed on dev"
  fi
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
