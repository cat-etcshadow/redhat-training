#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Tagged task demonstration
  hosts: all
  become: true
  tasks:
    - name: Install vim-enhanced
      ansible.builtin.dnf:
        name: vim-enhanced
        state: present
      tags:
        - packages

    - name: Create application config file
      ansible.builtin.copy:
        content: "configured=yes"
        dest: /etc/myapp.conf
      tags:
        - config

    - name: Ensure sshd is started
      ansible.builtin.service:
        name: sshd
        state: started
      tags:
        - service

    - name: Print inventory hostname
      ansible.builtin.debug:
        msg: "Running on {{ inventory_hostname }}"
      tags:
        - verify
        - always
EOF

chown student:student "$PLAYBOOK_FILE"
