#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

nmcli con show bond0 &>/dev/null || fail "bond0 connection does not exist"

mode=$(nmcli -g bond.options con show bond0 2>/dev/null | grep -o 'mode=[a-z-]*' | cut -d= -f2)
[[ "$mode" == "active-backup" ]] \
  || fail "bond0 mode is '$mode', expected active-backup"

ip link show bond0 &>/dev/null || fail "bond0 interface does not exist"
ip addr show bond0 | grep -q '10\.10\.0\.1/24' \
  || fail "10.10.0.1/24 not assigned to bond0"

[[ $errors -eq 0 ]] && exit 0 || exit 1
