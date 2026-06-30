## Hint

- Install: `dnf install -y rhel-system-roles` (run as root on control node)
- Roles are installed at `/usr/share/ansible/roles/` — check with `ls /usr/share/ansible/roles/`
- Role name: `rhel_system_roles.timesync`
- Required variable: `timesync_ntp_servers` — a list of server dicts with `hostname:` and optionally `iburst:`
- `iburst: yes` sends a burst of packets on initial sync for faster convergence
- Set variables in the play's `vars:` block, or in `group_vars/all.yml`
- `ansible-doc rhel_system_roles.timesync` for full variable reference
