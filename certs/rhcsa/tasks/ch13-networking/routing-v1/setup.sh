#!/usr/bin/env bash
# Remove static route if previously added (best-effort, connection name varies)
CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
if [[ -n "$CON" ]]; then
  nmcli connection modify "$CON" -ipv4.routes "${STATIC_NET} ${STATIC_GW}" 2>/dev/null || true
  nmcli connection up "$CON" &>/dev/null || true
fi
