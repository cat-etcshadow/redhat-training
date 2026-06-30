#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Set /etc/issue based on host group
  hosts: all
  become: true
  tasks:
    - name: Set issue for dev hosts
      ansible.builtin.copy:
        content: "$DEV_MSG\n"
        dest: /etc/issue
      when: "'dev' in group_names"

    - name: Set issue for test hosts
      ansible.builtin.copy:
        content: "$TEST_MSG\n"
        dest: /etc/issue
      when: "'test' in group_names"

    - name: Set issue for prod hosts
      ansible.builtin.copy:
        content: "$PROD_MSG\n"
        dest: /etc/issue
      when: "'prod' in group_names"
EOF
chown student:student "$PLAYBOOK_FILE"
