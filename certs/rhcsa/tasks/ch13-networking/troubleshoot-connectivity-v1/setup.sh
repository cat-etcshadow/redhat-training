#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || { echo "ERROR: no ethernet connection found"; exit 1; }
nmcli connection down "$CON" &>/dev/null || true
nmcli connection modify "$CON" connection.autoconnect no
