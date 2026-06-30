#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# check vault pass file
[[ -f "$VAULT_PASS_FILE" ]] || fail "vault password file not found at $VAULT_PASS_FILE"
grep -q "$VAULT_PASS" "$VAULT_PASS_FILE" \
  || fail "vault password file does not contain the correct password"

# check group_vars/all/ structure
[[ -d "$ANSIBLE_DIR/group_vars/all" ]] \
  || fail "group_vars/all/ directory does not exist"

# check plain vars file exists
PLAIN_FILE=""
for f in "$ANSIBLE_DIR/group_vars/all/main.yml" "$ANSIBLE_DIR/group_vars/all.yml"; do
  [[ -f "$f" ]] && PLAIN_FILE="$f" && break
done
[[ -n "$PLAIN_FILE" ]] || fail "group_vars/all/main.yml (or group_vars/all.yml) not found"
grep -qE "ntp_server\s*:" "$PLAIN_FILE" \
  || fail "plain group_vars file does not define ntp_server"

# check encrypted secrets file
[[ -f "$ANSIBLE_DIR/group_vars/all/secrets.yml" ]] \
  || fail "group_vars/all/secrets.yml not found"
head -1 "$ANSIBLE_DIR/group_vars/all/secrets.yml" | grep -q "\$ANSIBLE_VAULT" \
  || fail "group_vars/all/secrets.yml is not encrypted (missing \$ANSIBLE_VAULT header)"

# verify vault can decrypt with provided password
ansible-vault view --vault-password-file "$VAULT_PASS_FILE" \
  "$ANSIBLE_DIR/group_vars/all/secrets.yml" &>/dev/null \
  || fail "cannot decrypt secrets.yml with provided vault password"

# check playbook
[[ -f "$PLAYBOOK_FILE" ]] || fail "playbook not found at $PLAYBOOK_FILE"
python3 -c "import yaml,sys; yaml.safe_load(open('$PLAYBOOK_FILE'))" 2>/dev/null \
  || fail "invalid YAML in $PLAYBOOK_FILE"

grep -qE "db_password" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference db_password"

grep -qE "ntp_server" "$PLAYBOOK_FILE" \
  || fail "playbook does not reference ntp_server"

cd "$ANSIBLE_DIR"
ansible-playbook --syntax-check --vault-password-file "$VAULT_PASS_FILE" \
  -i "$ANSIBLE_DIR/inventory" "$PLAYBOOK_FILE" &>/dev/null \
  || fail "syntax check failed"

[[ $errors -eq 0 ]] && exit 0 || exit 1
