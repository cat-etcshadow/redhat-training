#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

grep -qE '^PermitRootLogin[[:space:]]+no' /etc/ssh/sshd_config \
  || fail "sshd_config does not set PermitRootLogin no"

grep -qE '^PasswordAuthentication[[:space:]]+no' /etc/ssh/sshd_config \
  || fail "sshd_config does not set PasswordAuthentication no"

sshd -t &>/dev/null || fail "sshd_config has a syntax error (sshd -t failed)"

systemctl is-active sshd &>/dev/null || fail "sshd is not running"

[[ $errors -eq 0 ]] && exit 0 || exit 1
