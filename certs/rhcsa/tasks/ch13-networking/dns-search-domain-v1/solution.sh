#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
nmcli con mod "$CON" ipv4.dns-search "$SEARCH_DOMAIN"
nmcli con up "$CON"
