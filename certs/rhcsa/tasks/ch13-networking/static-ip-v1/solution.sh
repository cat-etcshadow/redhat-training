#!/usr/bin/env bash
# shellcheck source=/dev/null
source /root/rhtr-static-ip-target.txt
CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
nmcli con mod "$CON" \
  ipv4.addresses "$STATIC_IP" \
  ipv4.gateway   "$GATEWAY" \
  ipv4.dns       "8.8.8.8 1.1.1.1" \
  ipv4.method    manual \
  connection.autoconnect yes
nmcli con up "$CON"
