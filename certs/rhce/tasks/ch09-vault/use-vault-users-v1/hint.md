## Hint

- `vars_files:` — list of YAML files to load as variables (plain or vault-encrypted)
- Hash a password: `"{{ mypassword | password_hash('sha512') }}"`
- Filter a list: `"{{ users | selectattr('job', 'equalto', 'developer') | list }}"`
- `loop:` iterates over a list; access current item with `item` (or `item.field`)
- `ansible.builtin.user` params: `name`, `uid`, `password`, `groups`, `append`
- `append: yes` adds to supplementary groups without removing existing ones
- Run with vault: `ansible-playbook --vault-password-file password.txt create_user.yml`
- `python3 -c "from passlib.hash import sha512_crypt; print(sha512_crypt.hash('redhat'))"` — generates hash manually for testing
