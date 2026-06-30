## Configure SELinux Using RHEL System Roles

Use the `rhel_system_roles.selinux` role to configure SELinux on all managed hosts.

### Steps:

1. Ensure the `rhel-system-roles` package is installed on the control node:
   ```
   sudo dnf install rhel-system-roles
   ```

2. Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that:
   - Uses the `rhel_system_roles.selinux` role
   - Sets `selinux_state: {{SELINUX_MODE}}`
   - Sets `selinux_reboot_ok: true` (allows the role to reboot if needed)
   - Includes a handler or post-task to handle the reboot that the role may request

Requirements:
- `rhel_system_roles.selinux` or `selinux` role must be referenced
- `selinux_state` must be set to `{{SELINUX_MODE}}`
- `selinux_reboot_ok: true` must be present
- The playbook must pass `--syntax-check`
