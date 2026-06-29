#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-enabled chronyd &>/dev/null || fail "chronyd is not enabled"
systemctl is-active  chronyd &>/dev/null || fail "chronyd is not running"

grep -q 'pool.ntp.org' /etc/chrony.conf \
  || fail "pool.ntp.org not configured in /etc/chrony.conf"

grep -qE '^allow[[:space:]]+192\.168\.0\.0/24' /etc/chrony.conf \
  || fail "allow 192.168.0.0/24 directive missing from /etc/chrony.conf"

[[ $errors -eq 0 ]] && exit 0 || exit 1
