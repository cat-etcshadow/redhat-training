#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-active firewalld &>/dev/null || fail "firewalld is not running"
systemctl is-enabled firewalld &>/dev/null || fail "firewalld is not enabled"

dz=$(firewall-cmd --get-default-zone 2>/dev/null)
[[ "$dz" == "internal" ]] || fail "default zone is $dz, expected internal"

[[ $errors -eq 0 ]] && exit 0 || exit 1
