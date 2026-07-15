#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || fail "no ethernet connection profile found"

state=$(nmcli -t -f GENERAL.STATE connection show "$CON" 2>/dev/null | cut -d: -f2)
[[ "$state" == "activated" ]] || fail "connection $CON is not activated"

autoconnect=$(nmcli -t -f connection.autoconnect connection show "$CON" 2>/dev/null | cut -d: -f2)
[[ "$autoconnect" == "yes" ]] || fail "connection $CON does not autoconnect at boot"

ping -c1 -W2 8.8.8.8 &>/dev/null || fail "no outbound network connectivity"

[[ $errors -eq 0 ]] && exit 0 || exit 1
