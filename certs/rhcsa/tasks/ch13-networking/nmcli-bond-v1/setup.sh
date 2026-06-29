#!/usr/bin/env bash
# Remove any existing bond0
nmcli con delete bond0 2>/dev/null || true
nmcli con delete bond0-slave 2>/dev/null || true
