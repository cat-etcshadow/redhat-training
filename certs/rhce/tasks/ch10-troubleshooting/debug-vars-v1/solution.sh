#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Debug variables on all managed hosts
  hosts: all
  tasks:
    - name: Print inventory hostname
      ansible.builtin.debug:
        msg: "Inventory hostname: {{ inventory_hostname }}"

    - name: Print OS family
      ansible.builtin.debug:
        msg: "OS family: {{ ansible_facts['os_family'] }}"

    - name: Print total memory in MB
      ansible.builtin.debug:
        msg: "Total memory: {{ ansible_facts['memtotal_mb'] }} MB"

    - name: Dump network interfaces
      ansible.builtin.debug:
        var: ansible_facts['interfaces']

    - name: Run uptime command
      ansible.builtin.command: uptime
      register: uptime_result

    - name: Print uptime output
      ansible.builtin.debug:
        msg: "Uptime: {{ uptime_result.stdout }}"
EOF
chown student:student "$PLAYBOOK_FILE"
