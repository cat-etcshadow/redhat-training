#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
nmcli connection modify "$CON" ipv4.dns "${DNS1} ${DNS2}" ipv4.ignore-auto-dns yes
nmcli connection up "$CON"
