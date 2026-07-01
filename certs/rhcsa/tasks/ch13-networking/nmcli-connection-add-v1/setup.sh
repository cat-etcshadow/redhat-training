#!/usr/bin/env bash
nmcli connection down "$CON_NAME" &>/dev/null || true
nmcli connection delete "$CON_NAME" &>/dev/null || true
ip link delete "$IFACE_NAME" &>/dev/null || true
