#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Install and enable $SERVICE_NAME with firewall
  hosts: all
  become: true
  tasks:
    - name: Install $SERVICE_NAME package
      ansible.builtin.dnf:
        name: $SERVICE_NAME
        state: present

    - name: Enable and start $SERVICE_NAME service
      ansible.builtin.service:
        name: $SERVICE_NAME
        state: started
        enabled: true

    - name: Open $FIREWALL_SERVICE in firewall
      ansible.posix.firewalld:
        service: $FIREWALL_SERVICE
        permanent: true
        state: enabled
        immediate: true
EOF

chown student:student "$PLAYBOOK_FILE"
