#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

grep -q '^Storage=persistent' /etc/systemd/journald.conf \
  || fail "/etc/systemd/journald.conf does not have 'Storage=persistent'"

grep -q "^SystemMaxUse=${MAX_USE}" /etc/systemd/journald.conf \
  || fail "/etc/systemd/journald.conf does not have 'SystemMaxUse=${MAX_USE}'"

systemctl is-active systemd-journald &>/dev/null \
  || fail "systemd-journald is not running after config change"

[[ -d /var/log/journal ]] \
  || fail "/var/log/journal directory does not exist (journald not writing persistently yet)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
