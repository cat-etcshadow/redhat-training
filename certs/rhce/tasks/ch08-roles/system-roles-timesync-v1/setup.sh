#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"
cat > "$ANSIBLE_DIR/ansible.cfg" <<'EOF'
[defaults]
inventory = /home/student/ansible/inventory
remote_user = student
host_key_checking = False
EOF
cat > "$INVENTORY_FILE" <<'EOF'
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

# ensure rhel-system-roles is installed
dnf install -y rhel-system-roles &>/dev/null || true

rm -f "$PLAYBOOK_FILE"
chown -R student:student "$ANSIBLE_DIR"
