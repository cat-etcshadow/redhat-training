## Create an Ansible Vault

1. Store the vault password **{{VAULT_PASS}}** in the file **{{VAULT_PASSWORD_FILE}}**.
   The file should contain only the password (no trailing spaces).

2. Create an encrypted vault file **{{VAULT_FILE}}** containing two variables:
   - `{{DEV_PASS_VAR}}` with value `redhat`
   - `{{MGR_PASS_VAR}}` with value `linux`

3. Use the password from **{{VAULT_PASSWORD_FILE}}** to encrypt the vault.

Requirements:
- The vault file must be encrypted (starts with `$ANSIBLE_VAULT;`)
- The vault must be decryptable with password `{{VAULT_PASS}}`
