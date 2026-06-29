#!/usr/bin/env bash
cat > /etc/sudoers.d/operator <<'EOF'
operator ALL=(root) NOPASSWD: /usr/bin/systemctl, /usr/sbin/useradd
EOF
chmod 0440 /etc/sudoers.d/operator
