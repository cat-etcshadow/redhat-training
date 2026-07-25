#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || fail "no active ethernet connection found"

search=$(nmcli -g ipv4.dns-search con show "$CON" 2>/dev/null)
echo "$search" | grep -q "$SEARCH_DOMAIN" \
  || fail "connection $CON does not have $SEARCH_DOMAIN configured as a DNS search domain"

grep -qE "^search.*${SEARCH_DOMAIN}" /etc/resolv.conf \
  || fail "/etc/resolv.conf does not reflect the $SEARCH_DOMAIN search domain"

[[ $errors -eq 0 ]] && exit 0 || exit 1
