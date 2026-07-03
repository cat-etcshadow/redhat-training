#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"
cat > "$INVENTORY_FILE" <<'EOF'
[local]
localhost ansible_connection=local
EOF
cat > "$PLAYBOOK_FILE" <<'EOF'
---
- name: Sample play
  hosts: local
  gather_facts: false
  tasks:
    - name: Print a message
      ansible.builtin.debug:
        msg: "navigator run OK"
EOF
rm -f "$NAVIGATOR_CFG"
chown -R student:student "$ANSIBLE_DIR"
