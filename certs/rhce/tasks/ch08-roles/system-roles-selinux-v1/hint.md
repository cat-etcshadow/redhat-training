## Hint

- Install RHEL system roles: `sudo dnf install rhel-system-roles`
- Roles are installed to: `/usr/share/ansible/roles/`
- Available roles: `ls /usr/share/ansible/roles/`
- The SELinux role key variables:
  - `selinux_state: enforcing|permissive|disabled`
  - `selinux_reboot_ok: true` — allows the role to reboot if a state change requires it
  - `selinux_policy: targeted` (default)
- The role handles the reboot internally when `selinux_reboot_ok: true`
- Verify syntax: `ansible-playbook --syntax-check selinux.yml`
- Full role documentation: `/usr/share/doc/rhel-system-roles/selinux/`
