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
rm -f "$MAIN_PLAYBOOK"
rm -rf "$ANSIBLE_DIR/tasks"
chown -R student:student "$ANSIBLE_DIR"
