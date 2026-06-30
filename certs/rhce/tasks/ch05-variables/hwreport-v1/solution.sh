#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'YAML'
---
- name: Generate hardware report
  hosts: all
  become: true
  tasks:
    - name: Write hardware report to file
      ansible.builtin.copy:
        dest: /root/hwreport.txt
        content: |
          INVENTORY_HOSTNAME={{ inventory_hostname }}
          TOTAL_MEMORY_IN_MB={{ ansible_facts['memtotal_mb'] | default('NONE') }}
          BIOS_VERSION={{ ansible_facts['bios_version'] | default('NONE') }}
YAML
chown student:student "$PLAYBOOK_FILE"
