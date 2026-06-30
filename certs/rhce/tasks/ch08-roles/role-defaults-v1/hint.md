## Hint

- Role defaults are the lowest priority variables — any other definition overrides them
- `defaults/main.yml` — lowest priority (designed to be overridden)
- `vars/main.yml` — higher priority (not easily overridden)
- To override a default, define the variable in the playbook's `vars:` section
- Variable precedence (low → high): role defaults → inventory vars → playbook vars → extra vars
- Role must be in a directory listed in `roles_path` in `ansible.cfg`, or in a `roles/` dir next to the playbook
- Test with: `ansible-playbook --syntax-check playbook.yml`
