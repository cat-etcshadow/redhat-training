#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$PLAYBOOK_FILE" ]]   || fail "playbook $PLAYBOOK_FILE does not exist"
[[ -f "$USER_VARS_FILE" ]]  || fail "user vars file $USER_VARS_FILE does not exist"

python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"
python3 -c "import yaml,sys; yaml.safe_load(open('$USER_VARS_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $USER_VARS_FILE"

# user list checks
python3 -c "
import yaml, sys
d = yaml.safe_load(open('$USER_VARS_FILE'))
users = d.get('users', [])
names = [u['name'] for u in users]
assert 'adam' in names,   'adam missing from user_list.yml'
assert 'gabriel' in names,'gabriel missing from user_list.yml'
assert 'lucifer' in names,'lucifer missing from user_list.yml'
" 2>&1 | while read -r line; do fail "$line"; done

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check -i "$INVENTORY_FILE" \
  --vault-password-file "$VAULT_PASSWORD_FILE" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "ansible-playbook --syntax-check failed (check vault password file path)"

grep -q "password_hash\|sha512" "$PLAYBOOK_FILE" \
  || fail "playbook does not use password_hash('sha512') filter"
grep -q "dev_pass\|mgr_pass" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference vault variables dev_pass or mgr_pass"
grep -q "devops"  "$PLAYBOOK_FILE" || fail "playbook does not add developers to devops group"
grep -q "opsmgr"  "$PLAYBOOK_FILE" || fail "playbook does not add managers to opsmgr group"
grep -q "loop\|with_items\|loop_var" "$PLAYBOOK_FILE" \
  || fail "playbook does not loop over users"

[[ $errors -eq 0 ]] && exit 0 || exit 1
