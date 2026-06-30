## Configure Time Synchronisation Using RHEL System Roles

Install the `rhel-system-roles` package if not already present, then create a playbook **{{PLAYBOOK_FILE}}** that:

1. Runs on **all** managed hosts
2. Uses the `timesync` RHEL system role
3. Configures the role with these variables:
   - `timesync_ntp_servers`: a list with one server `{{NTP_SERVER}}` and `iburst: yes`

Requirements:
- Reference the role as `rhel_system_roles.timesync` (or the short name `timesync` if configured)
- Set the role variables either in `vars:` at the play level or in group_vars
- The playbook must pass `--syntax-check`
- Use `become: true`
