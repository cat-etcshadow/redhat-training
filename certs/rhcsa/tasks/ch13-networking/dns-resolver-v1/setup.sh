#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
if [[ -n "$CON" ]]; then
  nmcli connection modify "$CON" ipv4.dns "" ipv4.ignore-auto-dns no 2>/dev/null || true
  nmcli connection up "$CON" &>/dev/null || true
fi
