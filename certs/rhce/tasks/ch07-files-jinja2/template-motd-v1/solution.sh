#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR/group_vars"

cat > "$ANSIBLE_DIR/group_vars/dev.yml" <<'EOF'
motd_message: "Welcome to Development"
EOF

cat > "$ANSIBLE_DIR/group_vars/test.yml" <<'EOF'
motd_message: "Welcome to Testing"
EOF

cat > "$ANSIBLE_DIR/group_vars/prod.yml" <<'EOF'
motd_message: "Welcome to Production"
EOF

cat > "$TEMPLATE_FILE" <<'EOF'
{{ motd_message }}
Managed by Ansible — hostname: {{ ansible_facts['hostname'] }}
EOF

cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Deploy MOTD template
  hosts: all
  become: true
  tasks:
    - name: Deploy /etc/motd from template
      ansible.builtin.template:
        src: $TEMPLATE_FILE
        dest: /etc/motd
EOF
chown -R student:student "$ANSIBLE_DIR"
