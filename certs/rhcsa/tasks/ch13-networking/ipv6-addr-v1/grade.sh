#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# address must appear in ip -6 addr
ip -6 addr show | grep -qi "$IPV6_ADDR" \
  || fail "IPv6 address $IPV6_ADDR not found in ip -6 addr show"

# prefix length must match
ip -6 addr show | grep -i "$IPV6_ADDR" | grep -q "/${IPV6_PREFIX}" \
  || fail "IPv6 address $IPV6_ADDR found but prefix /$IPV6_PREFIX is missing"

# must be configured via NetworkManager (persistent)
conn=$(nmcli -t -f NAME,TYPE connection show --active | grep ethernet | head -1 | cut -d: -f1)
if [[ -z "$conn" ]]; then
  conn=$(nmcli -t -f NAME connection show | head -1)
fi

nmcli connection show "$conn" 2>/dev/null | grep -qi 'ipv6.method.*manual' \
  || fail "IPv6 method is not 'manual' on connection '$conn' (not persistent via NM)"

nmcli connection show "$conn" 2>/dev/null | grep -i 'ipv6.addresses' | grep -qi "$IPV6_ADDR" \
  || fail "IPv6 address $IPV6_ADDR not found in NM connection '$conn' (config not persistent)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
