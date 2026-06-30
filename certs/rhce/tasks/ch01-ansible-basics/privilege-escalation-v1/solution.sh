#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Demonstrate privilege escalation
  hosts: dev
  become: true
  tasks:
    - name: Create system account $TARGET_USER
      ansible.builtin.user:
        name: $TARGET_USER
        system: true
        state: present

    - name: Write file as $TARGET_USER
      ansible.builtin.copy:
        content: "privilege escalation test"
        dest: /tmp/priv_test.txt
        owner: $TARGET_USER
      become_user: $TARGET_USER
EOF

chown student:student "$PLAYBOOK_FILE"
