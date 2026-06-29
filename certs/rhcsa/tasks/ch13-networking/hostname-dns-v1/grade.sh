#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

hostname=$(hostnamectl status | awk '/Static hostname/{print $3}')
[[ "$hostname" == "$FQDN" ]] \
  || fail "hostname is '$hostname', expected $FQDN"

ip_esc="${IP_ADDR//./\\.}"
grep -q "${ip_esc}.*${FQDN}\|${FQDN}.*${ip_esc}" /etc/hosts \
  || fail "No /etc/hosts entry mapping $IP_ADDR to $FQDN"

[[ $errors -eq 0 ]] && exit 0 || exit 1
