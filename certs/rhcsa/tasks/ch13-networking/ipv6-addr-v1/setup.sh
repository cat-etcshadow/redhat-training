#!/usr/bin/env bash
# remove any existing manual IPv6 config on all connections
for conn in $(nmcli -t -f NAME connection show); do
  nmcli connection modify "$conn" ipv6.method auto ipv6.addresses '' ipv6.gateway '' 2>/dev/null || true
done
