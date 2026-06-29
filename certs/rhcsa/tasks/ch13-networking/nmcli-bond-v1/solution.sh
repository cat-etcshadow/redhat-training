#!/usr/bin/env bash
SLAVE_DEV=$(nmcli -t -f DEVICE,STATE dev status | grep -v loopback | grep disconnected | head -1 | cut -d: -f1)
nmcli con add type bond ifname bond0 con-name bond0 \
  bond.options "mode=active-backup" \
  ipv4.addresses 10.10.0.1/24 \
  ipv4.method manual
nmcli con add type ethernet ifname "$SLAVE_DEV" con-name bond0-slave master bond0
nmcli con up bond0
