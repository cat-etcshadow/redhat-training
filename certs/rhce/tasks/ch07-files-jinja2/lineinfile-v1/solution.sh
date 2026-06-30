#!/usr/bin/env bash
# extract the directive keyword for the regexp (first word of CONFIG_LINE)
DIRECTIVE=$(echo "$CONFIG_LINE" | awk '{print $1}')

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Harden SSH configuration
  hosts: all
  become: true
  handlers:
    - name: restart sshd
      ansible.builtin.service:
        name: sshd
        state: restarted
  tasks:
    - name: Ensure $CONFIG_LINE is in sshd_config
      ansible.builtin.lineinfile:
        path: $CONFIG_FILE
        regexp: '^#?${DIRECTIVE}\\s'
        line: '$CONFIG_LINE'
        state: present
      notify: restart sshd

    - name: Disable PermitEmptyPasswords
      ansible.builtin.replace:
        path: $CONFIG_FILE
        regexp: '^#PermitEmptyPasswords.*'
        replace: 'PermitEmptyPasswords no'
      notify: restart sshd
EOF

chown student:student "$PLAYBOOK_FILE"
