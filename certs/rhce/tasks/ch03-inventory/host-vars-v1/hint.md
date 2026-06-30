## Hint

- `host_vars/` must be in the same directory as `ansible.cfg` or `inventory`
- Each file is named after the hostname: `host_vars/node1.yml`
- YAML format: `variable_name: value` (no quotes needed for integers)
- Ansible automatically loads `host_vars/` — no extra configuration needed
- Verify: `ansible -i inventory dev:test -m debug -a "var=http_port"`
- `group_vars/` works the same way but applies to a whole group
