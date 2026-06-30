#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure managed nodes for Ansible access
  hosts: all
  become: true
  tasks:
    - name: Create $ANSIBLE_USER user
      ansible.builtin.user:
        name: $ANSIBLE_USER
        state: present

    - name: Deploy SSH key for $ANSIBLE_USER
      ansible.posix.authorized_key:
        user: $ANSIBLE_USER
        key: "$SSH_KEY"
        state: present

    - name: Configure passwordless sudo for $ANSIBLE_USER
      ansible.builtin.copy:
        dest: /etc/sudoers.d/$ANSIBLE_USER
        content: "$ANSIBLE_USER ALL=(ALL) NOPASSWD: ALL\n"
        mode: '0440'
EOF
chown student:student "$PLAYBOOK_FILE"
