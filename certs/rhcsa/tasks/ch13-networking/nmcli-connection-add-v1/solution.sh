#!/usr/bin/env bash
nmcli connection add type dummy ifname "$IFACE_NAME" con-name "$CON_NAME" \
  ipv4.method manual ipv4.addresses "$IP_ADDR" autoconnect no
nmcli connection up "$CON_NAME"
