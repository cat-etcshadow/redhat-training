#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || fail "no ethernet connection found in NetworkManager"

dns_cfg=$(nmcli -g ipv4.dns connection show "$CON" 2>/dev/null)
echo "$dns_cfg" | grep -q "$DNS1" || fail "connection '$CON' is missing DNS server $DNS1"
echo "$dns_cfg" | grep -q "$DNS2" || fail "connection '$CON' is missing DNS server $DNS2"

grep -q "$DNS1" /etc/resolv.conf \
  || fail "/etc/resolv.conf does not include $DNS1 — was the connection brought back up?"

[[ $errors -eq 0 ]] && exit 0 || exit 1
