## Hint

- `group_vars/` must be in the same directory as the inventory or playbook
- File name = group name: `group_vars/dev.yml`, `group_vars/all.yml`
- Alternatively use a directory: `group_vars/dev/main.yml`
- YAML format: `key: value` (one per line, no quotes unless needed)
- Verify: `ansible-inventory -i inventory --host node1` shows merged vars for that host
- `group_vars/all.yml` applies to every host in every group
