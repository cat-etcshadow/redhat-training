#!/usr/bin/env bash
cat > "/etc/sudoers.d/$SUDO_USER" <<EOF
$SUDO_USER ALL=(root) NOPASSWD: $CMD1, $CMD2
EOF
chmod 0440 "/etc/sudoers.d/$SUDO_USER"
