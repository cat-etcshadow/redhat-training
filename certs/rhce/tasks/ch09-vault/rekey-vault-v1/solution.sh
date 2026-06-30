#!/usr/bin/env bash
printf '%s' "$OLD_VAULT_PASS" > /tmp/old_rk.txt
printf '%s' "$NEW_VAULT_PASS" > /tmp/new_rk.txt

ansible-vault rekey \
  --vault-password-file /tmp/old_rk.txt \
  --new-vault-password-file /tmp/new_rk.txt \
  "$VAULT_FILE"

rm -f /tmp/old_rk.txt /tmp/new_rk.txt
