#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Deploy /etc/motd to dev hosts
  hosts: dev
  become: true
  tasks:
    - name: Set /etc/motd content
      ansible.builtin.copy:
        content: "$CONFIG_CONTENT\n"
        dest: /etc/motd

    - name: Ensure ansible comment in /etc/motd
      ansible.builtin.lineinfile:
        path: /etc/motd
        line: "# managed by ansible"
        state: present
EOF

cat > "$ANSIBLE_DIR/check-mode.sh" <<EOF
#!/usr/bin/env bash
# syntax check first
ansible-playbook --syntax-check -i $ANSIBLE_DIR/inventory $PLAYBOOK_FILE
# run in check + diff mode to preview changes without applying them
ansible-playbook --check --diff -i $ANSIBLE_DIR/inventory $PLAYBOOK_FILE
EOF

chmod +x "$ANSIBLE_DIR/check-mode.sh"
chown student:student "$PLAYBOOK_FILE" "$ANSIBLE_DIR/check-mode.sh"
