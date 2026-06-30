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

# create vault with known password
printf '%s' "$VAULT_PASS" > "$VAULT_PASSWORD_FILE"
chmod 600 "$VAULT_PASSWORD_FILE"

ansible-vault create --vault-password-file "$VAULT_PASSWORD_FILE" "$VAULT_FILE" <<'VAULT'
dev_pass: redhat
mgr_pass: linux
VAULT

rm -f "$PLAYBOOK_FILE" "$USER_VARS_FILE"
chown -R student:student "$ANSIBLE_DIR"
