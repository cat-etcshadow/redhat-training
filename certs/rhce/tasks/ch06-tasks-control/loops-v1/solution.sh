#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Install packages and create users
  hosts: dev
  become: true
  tasks:
    - name: Install required packages
      ansible.builtin.dnf:
        name: "{{ item }}"
        state: present
      loop:
        - $PKG1
        - $PKG2
        - $PKG3

    - name: Create users
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
      loop:
        - $USER1
        - $USER2
        - $USER3
EOF
chown student:student "$PLAYBOOK_FILE"
