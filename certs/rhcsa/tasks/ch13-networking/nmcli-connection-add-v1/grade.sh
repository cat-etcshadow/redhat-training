#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

nmcli -t -f NAME connection show 2>/dev/null | grep -qx "$CON_NAME" \
  || fail "connection '$CON_NAME' does not exist"

autoconn=$(nmcli -g connection.autoconnect connection show "$CON_NAME" 2>/dev/null)
[[ "$autoconn" == "no" ]] \
  || fail "connection '$CON_NAME' has autoconnect='$autoconn', expected 'no'"

ip -4 addr show "$IFACE_NAME" 2>/dev/null | grep -q "${IP_ADDR%%/*}" \
  || fail "interface $IFACE_NAME does not have address $IP_ADDR applied"

[[ $errors -eq 0 ]] && exit 0 || exit 1
