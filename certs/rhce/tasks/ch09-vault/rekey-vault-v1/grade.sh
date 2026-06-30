#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$VAULT_FILE" ]] || fail "vault file $VAULT_FILE does not exist"

# must still be encrypted
head -1 "$VAULT_FILE" | grep -q '^\$ANSIBLE_VAULT;' \
  || fail "$VAULT_FILE is no longer encrypted"

# old password must NOT work
printf '%s' "$OLD_VAULT_PASS" > /tmp/old_pass_check.txt
ansible-vault view --vault-password-file /tmp/old_pass_check.txt "$VAULT_FILE" &>/dev/null \
  && fail "old password '$OLD_VAULT_PASS' still works — rekey was not performed" \
  || true
rm -f /tmp/old_pass_check.txt

# new password MUST work
printf '%s' "$NEW_VAULT_PASS" > /tmp/new_pass_check.txt
decrypted=$(ansible-vault view --vault-password-file /tmp/new_pass_check.txt "$VAULT_FILE" 2>/dev/null) \
  || fail "vault cannot be decrypted with new password '$NEW_VAULT_PASS'"
rm -f /tmp/new_pass_check.txt

echo "$decrypted" | grep -q "dev_pass" || fail "vault content missing dev_pass after rekey"
echo "$decrypted" | grep -q "mgr_pass" || fail "vault content missing mgr_pass after rekey"

[[ $errors -eq 0 ]] && exit 0 || exit 1
