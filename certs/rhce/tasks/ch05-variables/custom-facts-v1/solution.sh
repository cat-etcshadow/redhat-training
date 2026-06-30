#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Deploy and use custom facts
  hosts: all
  become: true
  tasks:
    - name: Ensure facts.d directory exists
      ansible.builtin.file:
        path: /etc/ansible/facts.d
        state: directory
        mode: '0755'

    - name: Deploy custom fact file
      ansible.builtin.copy:
        dest: /etc/ansible/facts.d/custom.fact
        content: |
          [packages]
          web_package = $FACT_PKG
          db_package = $FACT_SVC

    - name: Re-gather facts
      ansible.builtin.setup:

    - name: Print web_package custom fact
      ansible.builtin.debug:
        msg: "web_package is {{ ansible_local.custom.packages.web_package }}"
EOF
chown student:student "$PLAYBOOK_FILE"
