#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || exit 0
nmcli con mod "$CON" -ipv4.addresses "$SECONDARY_IP" 2>/dev/null || true
nmcli con up "$CON" &>/dev/null || true
