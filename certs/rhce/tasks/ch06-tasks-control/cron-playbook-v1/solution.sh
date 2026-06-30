#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Configure cron job on all managed hosts
  hosts: all
  become: true
  tasks:
    - name: Ensure user $CRON_USER exists
      ansible.builtin.user:
        name: $CRON_USER
        state: present

    - name: Create exam-logger cron job
      ansible.builtin.cron:
        name: exam-logger
        user: $CRON_USER
        minute: "*/$CRON_MINUTE"
        job: 'logger "EX294 exam in progress"'
EOF
chown student:student "$PLAYBOOK_FILE"
