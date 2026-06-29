#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

perm_services=$(firewall-cmd --permanent --zone=public --list-services 2>/dev/null)
echo "$perm_services" | grep -qw 'ssh' \
  && fail "ssh service is still in the public zone — should use rich rules only"

rich=$(firewall-cmd --permanent --zone=public --list-rich-rules 2>/dev/null)
echo "$rich" | grep -qi 'source address.*192\.168\.100\.0/24.*ssh.*accept\|ssh.*source.*192\.168\.100\.0/24.*accept' \
  || fail "No rich rule accepting SSH from 192.168.100.0/24"

echo "$rich" | grep -qi 'service name=.ssh.*reject\|ssh.*reject' \
  || fail "No rich rule rejecting SSH from other sources"

[[ $errors -eq 0 ]] && exit 0 || exit 1
