#!/usr/bin/env bash
printf '%s' "$VAULT_PASS" > "$VAULT_PASSWORD_FILE"
chmod 600 "$VAULT_PASSWORD_FILE"

ansible-vault create --vault-password-file "$VAULT_PASSWORD_FILE" "$VAULT_FILE" <<EOF
${DEV_PASS_VAR}: redhat
${MGR_PASS_VAR}: linux
EOF

chown student:student "$VAULT_FILE" "$VAULT_PASSWORD_FILE"
