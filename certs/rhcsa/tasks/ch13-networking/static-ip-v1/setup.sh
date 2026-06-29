#!/usr/bin/env bash
# Reset the primary connection to DHCP
CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || exit 0
nmcli con mod "$CON" ipv4.method auto ipv4.addresses "" ipv4.gateway "" ipv4.dns ""
nmcli con up "$CON" &>/dev/null || true
