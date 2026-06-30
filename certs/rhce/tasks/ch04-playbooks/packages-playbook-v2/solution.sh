#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Install $PKG1 and $PKG2 on webservers
  hosts: webservers
  become: true
  tasks:
    - name: Install webserver stack packages
      ansible.builtin.dnf:
        name:
          - $PKG1
          - $PKG2
        state: latest

- name: Install $PKG3 on dev hosts
  hosts: dev
  become: true
  tasks:
    - name: Install $PKG3
      ansible.builtin.dnf:
        name: $PKG3
        state: present

- name: Update all packages on test
  hosts: test
  become: true
  tasks:
    - name: Upgrade all packages to latest
      ansible.builtin.dnf:
        name: "*"
        state: latest
EOF

chown student:student "$PLAYBOOK_FILE"
