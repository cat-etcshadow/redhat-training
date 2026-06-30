## Hint

- Custom facts directory on managed hosts: `/etc/ansible/facts.d/`
- Files must end in `.fact` and use INI or JSON format
- INI format: `[section]` header, then `key = value` lines
- After deploying `.fact` files, re-run `ansible.builtin.setup` in the same play to load them
- Access custom facts: `ansible_local.<filename_without_.fact>.<section>.<key>`
- Example: `ansible_local.custom.packages.web_package`
- Use `ansible.builtin.debug: var: ansible_local` to dump all local facts
