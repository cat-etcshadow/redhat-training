#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure SELinux policy
  hosts: prod
  become: true
  tasks:
    - name: Set SELinux file context for $CUSTOM_DIR
      community.general.sefcontext:
        target: '${CUSTOM_DIR}(/.*)?'
        setype: $SELINUX_TYPE
        state: present

    - name: Apply file context with restorecon
      ansible.builtin.command: restorecon -Rv $CUSTOM_DIR

    - name: Enable SELinux boolean $SELINUX_BOOLEAN
      ansible.posix.seboolean:
        name: $SELINUX_BOOLEAN
        state: yes
        persistent: yes
EOF
chown student:student "$PLAYBOOK_FILE"
