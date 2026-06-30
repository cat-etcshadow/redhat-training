#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR" "$ROLES_DIR"
cat > "$ANSIBLE_DIR/ansible.cfg" <<EOF
[defaults]
inventory = $INVENTORY_FILE
remote_user = student
host_key_checking = False
roles_path = $ROLES_DIR
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
rm -f "$REQUIREMENTS_FILE"
rm -rf "$ROLES_DIR/apache" "$ROLES_DIR/mysql"
chown -R student:student "$ANSIBLE_DIR"
