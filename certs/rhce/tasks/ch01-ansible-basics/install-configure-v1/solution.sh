#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"

cat > "$CFG_FILE" <<'EOF'
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
EOF

chown -R student:student "$ANSIBLE_DIR"
