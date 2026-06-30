#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$VAULT_FILE" ]] \
  || fail "vault file $VAULT_FILE does not exist"
[[ -f "$VAULT_PASSWORD_FILE" ]] \
  || fail "password file $VAULT_PASSWORD_FILE does not exist"

# file must be encrypted
head -1 "$VAULT_FILE" | grep -q '^\$ANSIBLE_VAULT;' \
  || fail "$VAULT_FILE is not an ansible-vault encrypted file"

# password file must contain the correct password
stored_pass=$(cat "$VAULT_PASSWORD_FILE" | tr -d '\n')
[[ "$stored_pass" == "$VAULT_PASS" ]] \
  || fail "password in $VAULT_PASSWORD_FILE is '$stored_pass', expected '$VAULT_PASS'"

# vault must be decryptable with the password file
decrypted=$(ansible-vault view --vault-password-file "$VAULT_PASSWORD_FILE" "$VAULT_FILE" 2>/dev/null) \
  || fail "vault cannot be decrypted with the password in $VAULT_PASSWORD_FILE"

echo "$decrypted" | grep -q "${DEV_PASS_VAR}:\s*redhat\|${DEV_PASS_VAR}: redhat" \
  || fail "vault does not contain ${DEV_PASS_VAR}: redhat"
echo "$decrypted" | grep -q "${MGR_PASS_VAR}:\s*linux\|${MGR_PASS_VAR}: linux" \
  || fail "vault does not contain ${MGR_PASS_VAR}: linux"

[[ $errors -eq 0 ]] && exit 0 || exit 1
