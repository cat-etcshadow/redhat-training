#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: OS-conditional configuration
  hosts: all
  become: true
  tasks:
    - name: Install $PACKAGE on RedHat systems
      ansible.builtin.dnf:
        name: $PACKAGE
        state: present
      when: ansible_distribution == "RedHat"

    - name: Create status file on RedHat family
      ansible.builtin.copy:
        dest: $STATUS_FILE
        content: "RedHat system configured"
      when: ansible_os_family == "RedHat"

    - name: Check available memory
      ansible.builtin.debug:
        msg: "Sufficient memory available"
      when: ansible_memtotal_mb > $MIN_MEMORY
EOF
chown student:student "$PLAYBOOK_FILE"
