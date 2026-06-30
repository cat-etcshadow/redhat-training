## Hint

- Ansible automatically collects facts when a play runs (setup module)
- Key facts: `ansible_facts['memtotal_mb']`, `ansible_facts['bios_version']`, `inventory_hostname`
- Use `| default('NONE')` filter to handle missing facts gracefully
- `ansible.builtin.copy` with `content:` writes a string directly to a file
- Use a multi-line `content:` block with `|` for a literal block scalar in YAML
- Test facts for a host: `ansible node1 -m ansible.builtin.setup -i inventory`
