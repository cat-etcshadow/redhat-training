## Hint

- Split group_vars into a directory: `group_vars/all/` can contain multiple files
- Plain file `main.yml` holds non-sensitive vars; `secrets.yml` holds encrypted vars
- Encrypt an existing file: `ansible-vault encrypt --vault-password-file .vault_pass secrets.yml`
- Create encrypted directly: `ansible-vault create --vault-password-file .vault_pass secrets.yml`
- The encrypted file starts with `$ANSIBLE_VAULT;1.1;AES256` header
- Run playbook with vault: `ansible-playbook --vault-password-file .vault_pass playbook.yml`
- Or set in `ansible.cfg`: `vault_password_file = /path/to/.vault_pass`
- View encrypted file: `ansible-vault view --vault-password-file .vault_pass secrets.yml`
