#!/usr/bin/env bash
mkdir -p /etc/rhtr-app
cat > "$CONF_FILE" << 'EOF'
# Server configuration — update the placeholder values below
HOSTNAME=placeholder.invalid
LISTEN_PORT=0
TIMEOUT=0
DEBUG=true
EOF
