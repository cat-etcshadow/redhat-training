#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# Check route is active in kernel
ip route show | grep -q "${STATIC_NET}" \
  || fail "Route to ${STATIC_NET} not found in 'ip route show'"

ip route show | grep "${STATIC_NET}" | grep -q "${STATIC_GW}" \
  || fail "Route to ${STATIC_NET} exists but not via gateway ${STATIC_GW}"

# Check route is persistent in NetworkManager connection
CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || fail "No ethernet connection found in NetworkManager"

nmcli connection show "$CON" 2>/dev/null | grep -q "ipv4.routes.*${STATIC_NET}" \
  || fail "Route ${STATIC_NET} is not saved in connection '$CON' (not persistent)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
