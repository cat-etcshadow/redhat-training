#!/usr/bin/env bash
CON=$(nmcli -t -f NAME,TYPE con show --active | grep ethernet | head -1 | cut -d: -f1)
[[ -n "$CON" ]] || exit 0

# Derive the static target from the live DHCP lease instead of a hardcoded
# 10.0.0.0/24 — the lab bridge's actual subnet varies per deployment (e.g.
# it's 10.79.22.0/24 on this host), so a fixed literal used to leave the
# VM's only NIC pointed at an unreachable gateway once the candidate
# completed this task correctly, breaking real outbound connectivity for
# the rest of the exam (including troubleshoot-connectivity-v1's ping
# check, guaranteed co-drawn since both live in ch13-networking).
CIDR=$(nmcli -g IP4.ADDRESS con show "$CON" | head -1)   # e.g. 10.79.22.23/24
GW=$(nmcli -g IP4.GATEWAY con show "$CON" | head -1)
PREFIX="${CIDR#*/}"
NET="${CIDR%.*}"                                          # e.g. 10.79.22
STATIC_IP="${NET}.50/${PREFIX}"

cat > /root/rhtr-static-ip-target.txt <<EOF
STATIC_IP=$STATIC_IP
GATEWAY=$GW
EOF

# Reset the primary connection to DHCP so the candidate starts from a known baseline
nmcli con mod "$CON" ipv4.method auto ipv4.addresses "" ipv4.gateway "" ipv4.dns ""
nmcli con up "$CON" &>/dev/null || true
