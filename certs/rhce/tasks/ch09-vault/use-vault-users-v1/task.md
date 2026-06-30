## Create Users Using Vault Passwords

**Step 1:** Create **{{USER_VARS_FILE}}** with the following user list:
```yaml
users:
  - name: adam
    job: developer
    uid: 3000
  - name: gabriel
    job: manager
    uid: 3001
  - name: lucifer
    job: developer
    uid: 3002
```

**Step 2:** A vault file **{{VAULT_FILE}}** (password: `{{VAULT_PASS}}`) already contains:
- `dev_pass: redhat`
- `mgr_pass: linux`

**Step 3:** Create a playbook **{{PLAYBOOK_FILE}}** that creates users as follows:

- Users with `job: developer` → created on **dev** and **test** hosts, password from `dev_pass`, added to supplementary group `devops`
- Users with `job: manager` → created on **prod** hosts, password from `mgr_pass`, added to supplementary group `opsmgr`
- Passwords must use the **SHA512** hash format (`password_hash('sha512')` filter)
- The playbook must work with `--vault-password-file {{VAULT_PASSWORD_FILE}}`
