## Hint

- `ansible.cfg` lives in the working directory or `/etc/ansible/ansible.cfg` — per-project file takes precedence
- `[defaults]` section controls inventory, remote_user, host_key_checking
- Inventory child groups: `[webservers:children]` then list the child group names below it
- Test with: `ansible-inventory --graph` to visualise the group hierarchy
- Test connectivity: `ansible all -m ping`
