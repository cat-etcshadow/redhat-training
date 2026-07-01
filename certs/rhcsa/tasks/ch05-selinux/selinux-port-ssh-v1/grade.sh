#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

semanage port -l 2>/dev/null | grep -q "ssh_port_t.*tcp.*\b${SSH_PORT}\b" \
  || fail "Port $SSH_PORT/tcp is not assigned to SELinux ssh_port_t"

systemctl is-active sshd &>/dev/null || fail "sshd is not running"

grep -qE "^Port[[:space:]]+${SSH_PORT}\$" /etc/ssh/sshd_config \
  || fail "sshd_config is not configured to listen on port $SSH_PORT"

ss -ltn 2>/dev/null | grep -q ":${SSH_PORT}[[:space:]]" \
  || fail "sshd is not actually listening on port $SSH_PORT"

[[ $errors -eq 0 ]] && exit 0 || exit 1
