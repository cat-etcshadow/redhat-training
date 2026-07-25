#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || fail "no active ethernet connection found"

DEV=$(nmcli -t -f NAME,DEVICE con show --active | grep "^${CON}:" | cut -d: -f2)
[[ -n "$DEV" ]] || fail "could not determine device for connection $CON"

ip -4 addr show dev "$DEV" | grep -q "${SECONDARY_IP}" \
  || fail "$SECONDARY_IP is not configured on $DEV"

addr_count=$(ip -4 addr show dev "$DEV" | grep -c 'inet ')
(( addr_count >= 2 )) \
  || fail "expected at least 2 IPv4 addresses on $DEV (original + secondary), found $addr_count"

[[ $errors -eq 0 ]] && exit 0 || exit 1
