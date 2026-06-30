## Hint

- Rekey with prompts: `ansible-vault rekey vault.yml` (prompts for current password then new password)
- Rekey with files: `ansible-vault rekey --vault-password-file old.txt --new-vault-password-file new.txt vault.yml`
- `--vault-password-file` — provides the current (old) password
- `--new-vault-password-file` — provides the replacement password
- After rekeying, the file header stays the same (`$ANSIBLE_VAULT;1.1;AES256`) but the content is re-encrypted
- Verify: `ansible-vault view --vault-password-file new.txt vault.yml`
