#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

grep -q '^Storage=persistent' /etc/systemd/journald.conf \
  || fail "Storage=persistent not set in /etc/systemd/journald.conf"

grep -q '^SystemMaxUse=100M' /etc/systemd/journald.conf \
  || fail "SystemMaxUse=100M not set in /etc/systemd/journald.conf"

[[ -d /var/log/journal ]] || fail "/var/log/journal directory does not exist"

systemctl is-active systemd-journald &>/dev/null \
  || fail "systemd-journald is not running"

[[ $errors -eq 0 ]] && exit 0 || exit 1
