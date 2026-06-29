#!/usr/bin/env bash
conn=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
nmcli connection modify "$conn" \
  ipv6.method manual \
  ipv6.addresses "${IPV6_ADDR}/${IPV6_PREFIX}" \
  ipv6.gateway "$IPV6_GW"
nmcli connection down "$conn" && nmcli connection up "$conn"
