## Encrypt a group_vars Secrets File with Vault

Set up group variables with a split structure — plain variables in one file, sensitive variables in an encrypted vault file:

### Step 1: Create the plain group_vars file

Create `{{ANSIBLE_DIR}}/group_vars/all/main.yml` with:
```yaml
ntp_server: 172.25.254.250
```

### Step 2: Create the vault password file

Write the vault password to **{{VAULT_PASS_FILE}}** and set restrictive permissions on it.

### Step 3: Create the encrypted secrets file

Create an encrypted file at `{{ANSIBLE_DIR}}/group_vars/all/secrets.yml` containing:
```yaml
db_password: "s3cr3t"
api_key: "abc123"
```
Encrypt it with `ansible-vault` using the password file from Step 2.

### Step 4: Create a playbook

Create **{{PLAYBOOK_FILE}}** for **all** hosts that prints both `ntp_server` and `db_password` using `ansible.builtin.debug`.

Verify:
```
ansible-playbook --vault-password-file {{VAULT_PASS_FILE}} {{PLAYBOOK_FILE}} --syntax-check
```
