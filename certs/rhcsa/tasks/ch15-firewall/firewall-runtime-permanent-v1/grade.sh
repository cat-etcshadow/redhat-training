#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

systemctl is-active firewalld &>/dev/null || fail "firewalld is not running"

runtime=$(firewall-cmd --zone=public --list-services 2>/dev/null)
permanent=$(firewall-cmd --permanent --zone=public --list-services 2>/dev/null)

echo "$runtime" | grep -qw ftp \
  || fail "ftp is not active in the current runtime configuration"
echo "$permanent" | grep -qw ftp \
  && fail "ftp should not be present in the permanent configuration"

echo "$runtime" | grep -qw smtp \
  || fail "smtp is not active in the current runtime configuration"
echo "$permanent" | grep -qw smtp \
  || fail "smtp should be present in the permanent configuration"

[[ $errors -eq 0 ]] && exit 0 || exit 1
