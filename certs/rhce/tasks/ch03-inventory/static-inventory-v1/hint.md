## Hint

- INI-format inventory: `[groupname]` header, then hostnames one per line
- Child groups syntax: `[parent:children]` then list child group names
- Example: `[webservers:children]` / `prod` / `balancers`
- Validate: `ansible-inventory --graph` shows the full tree
- Validate hosts in groups: `ansible-inventory --graph -i inventory`
