#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Classify hosts using set_fact and magic variables
  hosts: all
  gather_facts: false
  tasks:
    - name: Set server_role for dev hosts
      ansible.builtin.set_fact:
        server_role: "development server"
      when: "'dev' in group_names"

    - name: Set server_role for prod hosts
      ansible.builtin.set_fact:
        server_role: "production server"
      when: "'prod' in group_names"

    - name: Set server_role for other hosts
      ansible.builtin.set_fact:
        server_role: "other server"
      when: "'dev' not in group_names and 'prod' not in group_names"

    - name: Print server_role for this host
      ansible.builtin.debug:
        msg: "{{ inventory_hostname }} is a {{ server_role }}"

    - name: Print number of production hosts
      ansible.builtin.debug:
        msg: "There are {{ groups['prod'] | length }} production hosts"
EOF

chown student:student "$PLAYBOOK_FILE"
