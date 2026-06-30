## Hint

- Create vault: `ansible-vault create --vault-password-file password.txt vault.yml`
- Edit existing vault: `ansible-vault edit --vault-password-file password.txt vault.yml`
- View vault contents: `ansible-vault view --vault-password-file password.txt vault.yml`
- The password file must contain only the password, no trailing newline issues matter — ansible handles it
- Inside the vault file, content is plain YAML: `dev_pass: redhat`
- The vault file header `$ANSIBLE_VAULT;1.1;AES256` confirms it's encrypted
