#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"
cat > "$ANSIBLE_DIR/ansible.cfg" <<'EOF'
[defaults]
inventory = /home/student/ansible/inventory
remote_user = student
host_key_checking = False
EOF
cat > "$ANSIBLE_DIR/inventory" <<'EOF'
[dev]
node1

[test]
node2

[prod]
node3
node4

[balancers]
node5

[webservers:children]
prod
balancers
EOF

# create the broken playbook with intentional errors
cat > "$PLAYBOOK_FILE" <<'BROKEN'
---
- name: Broken logic playbook
  hosts: all
  gather_facts: false
  tasks:
    - name: Dev-only task with wrong condition
      ansible.builtin.debug:
        msg: "This is a dev host"
      when: group_names == 'dev'

    - name: Install packages from list
      ansible.builtin.debug:
        msg: "Install {{ item }}"
      loop:
        - name: httpd
          version: latest
        - name: vim
          version: present

    - name: Run command and use output
      ansible.builtin.command: echo hello
      register: result

    - name: Print command output
      ansible.builtin.debug:
        msg: "{{ result.output }}"
BROKEN

chown -R student:student "$ANSIBLE_DIR"
