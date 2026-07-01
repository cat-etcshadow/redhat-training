## Encrypt a group_vars Secrets File with Vault

Set up group variables with a split structure — plain variables in one file, sensitive variables in an encrypted vault file:

1. Create `{{ANSIBLE_DIR}}/group_vars/all/main.yml` with:
   ```yaml
   ntp_server: 172.25.254.250
   ```

2. Write the vault password to **{{VAULT_PASS_FILE}}** and set restrictive permissions on it.

3. Create an encrypted file at `{{ANSIBLE_DIR}}/group_vars/all/secrets.yml` containing:
   ```yaml
   db_password: "s3cr3t"
   api_key: "abc123"
   ```
   Encrypt it with `ansible-vault` using the password file from step 2.

4. Create **{{PLAYBOOK_FILE}}** for **all** hosts that prints both `ntp_server` and `db_password` using `ansible.builtin.debug`.

Requirements:
- The playbook must pass `--syntax-check` using `{{VAULT_PASS_FILE}}`
