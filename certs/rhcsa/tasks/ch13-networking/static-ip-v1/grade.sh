#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -f /root/rhtr-static-ip-target.txt ]] || fail "target file /root/rhtr-static-ip-target.txt missing"
# shellcheck source=/dev/null
source /root/rhtr-static-ip-target.txt

# target IP must be assigned to some interface (not lo)
ip addr | grep -v 'scope host lo' | grep -qF "$STATIC_IP" \
  || fail "IP $STATIC_IP is not configured on any interface"

# Check NM connection is manual
CON=$(nmcli -t -f NAME,TYPE,DEVICE con show | grep ethernet | head -1 | cut -d: -f1)
method=$(nmcli -g ipv4.method con show "$CON" 2>/dev/null)
[[ "$method" == "manual" ]] \
  || fail "Connection '$CON' is still using method '$method', expected manual"

gw=$(nmcli -g ipv4.gateway con show "$CON" 2>/dev/null)
[[ "$gw" == "$GATEWAY" ]] || fail "gateway is '$gw', expected '$GATEWAY'"

dns=$(nmcli -g ipv4.dns con show "$CON" 2>/dev/null)
echo "$dns" | grep -q '8.8.8.8' || fail "DNS 8.8.8.8 not configured"
echo "$dns" | grep -q '1.1.1.1' || fail "DNS 1.1.1.1 not configured"

[[ $errors -eq 0 ]] && exit 0 || exit 1
