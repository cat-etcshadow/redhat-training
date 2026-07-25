#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR"
cat > "$ANSIBLE_DIR/ansible.cfg" <<'EOF'
[defaults]
inventory = /home/student/ansible/inventory
remote_user = student
host_key_checking = False
EOF
# Scoped to only the nodes this scenario's NEEDS_NODES actually builds
# (node3, node4) — unlike the training pool's tasks/, which conventionally
# writes a full 5-node inventory regardless of what a task uses.
cat > "$INVENTORY_FILE" <<'EOF'
[prod]
node3
node4
EOF
rm -f "$PLAYBOOK_FILE"
chown -R student:student "$ANSIBLE_DIR"
