#!/usr/bin/env bash
mkdir -p "$ROLES_DIR" "$COLLECTIONS_DIR"

cat > "$CFG_FILE" <<EOF
[defaults]
inventory = /home/student/ansible/inventory
remote_user = student
host_key_checking = False
forks = $FORKS
log_path = $LOG_PATH
roles_path = $ROLES_DIR
collections_paths = $COLLECTIONS_DIR
stdout_callback = yaml
EOF

chown -R student:student "$ANSIBLE_DIR"
