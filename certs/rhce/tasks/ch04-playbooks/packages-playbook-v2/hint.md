## Hint

- A playbook is a list of plays — use `---` at the top and multiple `- name:` blocks
- Each play has its own `hosts:`, `become:`, and `tasks:` section
- `state: latest` installs or upgrades to the latest available version
- `name: "*"` with `state: latest` updates all installed packages
- Multiple packages in one task: use a YAML list under `name:`
- Verify group targeting: `ansible-inventory --graph` to see group membership
