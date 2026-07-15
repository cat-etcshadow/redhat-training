#!/usr/bin/env bash
# investigate:
# nmcli con show
# nmcli device status
CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
nmcli connection modify "$CON" connection.autoconnect yes
nmcli connection up "$CON"
