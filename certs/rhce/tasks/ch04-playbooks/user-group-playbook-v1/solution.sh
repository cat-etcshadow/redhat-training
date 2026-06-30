#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Manage users, groups, and SSH keys
  hosts: prod
  become: true
  tasks:
    - name: Create group $GROUP_NAME
      ansible.builtin.group:
        name: $GROUP_NAME
        gid: $GROUP_GID
        state: present

    - name: Create user $USER_NAME
      ansible.builtin.user:
        name: $USER_NAME
        uid: $USER_UID
        group: $GROUP_NAME
        shell: $USER_SHELL
        state: present

    - name: Deploy SSH key for $USER_NAME
      ansible.posix.authorized_key:
        user: $USER_NAME
        key: "$SSH_KEY"
        state: present
EOF
chown student:student "$PLAYBOOK_FILE"
