#!/usr/bin/env bash
mkdir -p "$ANSIBLE_DIR/group_vars"

cat > "$ANSIBLE_DIR/group_vars/dev.yml" <<EOF
env: $DEV_ENV
EOF

cat > "$ANSIBLE_DIR/group_vars/test.yml" <<EOF
env: $TEST_ENV
EOF

cat > "$ANSIBLE_DIR/group_vars/prod.yml" <<EOF
env: $PROD_ENV
EOF

cat > "$ANSIBLE_DIR/group_vars/all.yml" <<'EOF'
ntp_server: 172.25.254.250
EOF

chown -R student:student "$ANSIBLE_DIR/group_vars"
