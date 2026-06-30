## Rekey an Existing Ansible Vault

A vault file **{{VAULT_FILE}}** exists and is encrypted with the password `{{OLD_VAULT_PASS}}`.

Your task:
1. Rekey the vault file so it is encrypted with the **new** password `{{NEW_VAULT_PASS}}`
2. The vault file must remain encrypted after rekeying
3. The original content must be preserved (the variables inside must not change)

Verify: `ansible-vault view --ask-vault-pass {{VAULT_FILE}}` (using new password) must show the variables.
