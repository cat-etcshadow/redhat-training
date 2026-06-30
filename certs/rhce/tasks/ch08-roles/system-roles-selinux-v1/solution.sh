#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure SELinux using system roles
  hosts: all
  become: true
  vars:
    selinux_state: $SELINUX_MODE
    selinux_reboot_ok: true
  roles:
    - rhel_system_roles.selinux
EOF

chown student:student "$PLAYBOOK_FILE"
