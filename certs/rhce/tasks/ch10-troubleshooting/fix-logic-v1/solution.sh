#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Fixed logic playbook
  hosts: all
  gather_facts: false
  tasks:
    - name: Dev-only task with correct condition
      ansible.builtin.debug:
        msg: "This is a dev host"
      when: "'dev' in group_names"

    - name: Install packages from list
      ansible.builtin.debug:
        msg: "Install {{ item.name }}"
      loop:
        - name: httpd
          version: latest
        - name: vim
          version: present

    - name: Run command and use output
      ansible.builtin.command: echo hello
      register: result

    - name: Print command output
      ansible.builtin.debug:
        msg: "{{ result.stdout }}"
EOF

chown student:student "$PLAYBOOK_FILE"
