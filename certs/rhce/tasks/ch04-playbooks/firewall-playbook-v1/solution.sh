#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure firewall rules
  hosts: webservers
  become: true
  tasks:
    - name: Open $FW_SERVICE service
      ansible.posix.firewalld:
        service: $FW_SERVICE
        permanent: true
        immediate: true
        state: enabled

    - name: Open port ${FW_PORT}/tcp
      ansible.posix.firewalld:
        port: ${FW_PORT}/tcp
        permanent: true
        immediate: true
        state: enabled
EOF
chown student:student "$PLAYBOOK_FILE"
