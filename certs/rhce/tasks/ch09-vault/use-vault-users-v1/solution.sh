#!/usr/bin/env bash
cat > "$USER_VARS_FILE" <<'EOF'
users:
  - name: adam
    job: developer
    uid: 3000
  - name: gabriel
    job: manager
    uid: 3001
  - name: lucifer
    job: developer
    uid: 3002
EOF

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Create developer users on dev and test hosts
  hosts: dev:test
  become: true
  vars_files:
    - $USER_VARS_FILE
    - $VAULT_FILE
  tasks:
    - name: Ensure devops group exists
      ansible.builtin.group:
        name: devops
        state: present

    - name: Create developer users
      ansible.builtin.user:
        name: "{{ item.name }}"
        uid: "{{ item.uid }}"
        password: "{{ dev_pass | password_hash('sha512') }}"
        groups: devops
        append: yes
      loop: "{{ users | selectattr('job', 'equalto', 'developer') | list }}"

- name: Create manager users on prod hosts
  hosts: prod
  become: true
  vars_files:
    - $USER_VARS_FILE
    - $VAULT_FILE
  tasks:
    - name: Ensure opsmgr group exists
      ansible.builtin.group:
        name: opsmgr
        state: present

    - name: Create manager users
      ansible.builtin.user:
        name: "{{ item.name }}"
        uid: "{{ item.uid }}"
        password: "{{ mgr_pass | password_hash('sha512') }}"
        groups: opsmgr
        append: yes
      loop: "{{ users | selectattr('job', 'equalto', 'manager') | list }}"
EOF
chown student:student "$PLAYBOOK_FILE" "$USER_VARS_FILE"
