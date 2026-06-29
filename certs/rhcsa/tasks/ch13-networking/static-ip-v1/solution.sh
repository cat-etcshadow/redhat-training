#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
nmcli con mod "$CON" \
  ipv4.addresses 10.0.0.50/24 \
  ipv4.gateway   10.0.0.1 \
  ipv4.dns       "8.8.8.8 1.1.1.1" \
  ipv4.method    manual \
  connection.autoconnect yes
nmcli con up "$CON"
