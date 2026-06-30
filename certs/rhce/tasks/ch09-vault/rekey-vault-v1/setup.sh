#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"

# create vault with old password
printf '%s' "$OLD_VAULT_PASS" > /tmp/old_vault_pass.txt
ansible-vault create --vault-password-file /tmp/old_vault_pass.txt "$VAULT_FILE" <<'VAULT'
dev_pass: redhat
mgr_pass: linux
VAULT
rm -f /tmp/old_vault_pass.txt

chown student:student "$VAULT_FILE"
