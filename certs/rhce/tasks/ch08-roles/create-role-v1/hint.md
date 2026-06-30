## Hint

- Create role structure: `ansible-galaxy role init roles/apache`
- Standard role directories: `tasks/`, `handlers/`, `templates/`, `defaults/`, `vars/`, `meta/`
- `tasks/main.yml` — list of tasks (no play wrapper, just a list starting with `---`)
- `handlers/main.yml` — same format as tasks, but they are handlers
- Templates live in `templates/` and are referenced by filename only (no path prefix)
- Apply a role in a playbook: `roles:` list under the play, then `- rolename`
- `roles_path` in ansible.cfg tells Ansible where to find roles
- `ansible-doc ansible.posix.firewalld` for firewall module — use `service: http` (not port)
