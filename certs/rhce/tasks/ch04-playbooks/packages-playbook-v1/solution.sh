#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Install php and mariadb on dev, test, prod
  hosts: dev:test:prod
  become: true
  tasks:
    - name: Install php and mariadb
      ansible.builtin.dnf:
        name:
          - php
          - mariadb
        state: present

- name: Dev-only package tasks
  hosts: dev
  become: true
  tasks:
    - name: Install RPM Development Tools group
      ansible.builtin.dnf:
        name: "@RPM Development Tools"
        state: present

    - name: Update all packages to latest
      ansible.builtin.dnf:
        name: "*"
        state: latest
EOF
chown student:student "$PLAYBOOK_FILE"
