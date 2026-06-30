#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE connection show | grep ethernet | head -1 | cut -d: -f1)
nmcli connection modify "$CON" +ipv4.routes "$STATIC_NET $STATIC_GW"
nmcli connection up "$CON"
