#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-enabled firewalld &>/dev/null || fail "firewalld is not enabled"
systemctl is-active  firewalld &>/dev/null || fail "firewalld is not running"

firewall-cmd --zone=public --list-services 2>/dev/null | grep -q 'http' \
  || fail "http service not allowed in public zone"
firewall-cmd --zone=public --list-services 2>/dev/null | grep -q 'https' \
  || fail "https service not allowed in public zone"

# Must be permanent
firewall-cmd --permanent --zone=public --list-services 2>/dev/null | grep -q 'http' \
  || fail "http service not permanently allowed"
firewall-cmd --permanent --zone=public --list-services 2>/dev/null | grep -q 'https' \
  || fail "https service not permanently allowed"

[[ $errors -eq 0 ]] && exit 0 || exit 1
