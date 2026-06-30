## Hint

- YAML inventories start with `all:` as the top-level key
- Use `children:` to define groups, `hosts:` to list members
- Hostnames are keys with an empty value (`hostname:`) or `null`
- Child groups are referenced by name under a group's `children:` key
- Verify: `ansible-inventory -i inventory.yaml --graph`
- Verify all hosts: `ansible-inventory -i inventory.yaml --list`
- The file extension `.yaml` or `.yml` signals YAML format to Ansible
