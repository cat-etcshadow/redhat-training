## Hint

- The `ansible-navigator.yml` schema is a single top-level `ansible-navigator:` key
- `execution-environment: enabled: false` runs playbooks with the local
  Ansible install instead of pulling a container image
- `inventory: entries: [path]` (a list) sets the default inventory
- `ansible-navigator run PLAYBOOK -m stdout` runs non-interactively and
  prints output like `ansible-playbook`
- `ANSIBLE_NAVIGATOR_CONFIG=/path/to/ansible-navigator.yml` points navigator
  at a config file outside the current directory
