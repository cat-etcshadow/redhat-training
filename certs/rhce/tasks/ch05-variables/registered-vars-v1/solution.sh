#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Check service status using registered variables
  hosts: all
  tasks:
    - name: Check if $CHECK_SERVICE is active
      ansible.builtin.command: systemctl is-active $CHECK_SERVICE
      register: svc_result
      ignore_errors: true

    - name: Report service running
      ansible.builtin.debug:
        msg: "$CHECK_SERVICE is running"
      when: svc_result.rc == 0

    - name: Report service stopped
      ansible.builtin.debug:
        msg: "$CHECK_SERVICE is stopped"
      when: svc_result.rc != 0

    - name: Print host uptime
      ansible.builtin.debug:
        msg: "Uptime: {{ ansible_facts['uptime_seconds'] }} seconds"
EOF

chown student:student "$PLAYBOOK_FILE"
