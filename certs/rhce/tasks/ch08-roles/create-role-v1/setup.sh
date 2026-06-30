#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"
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
rm -rf "$ROLES_DIR/$ROLE_NAME" "$PLAYBOOK_FILE"
mkdir -p "$ROLES_DIR"
chown -R student:student "$ANSIBLE_DIR"
