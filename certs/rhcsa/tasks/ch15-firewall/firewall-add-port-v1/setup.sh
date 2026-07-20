#!/usr/bin/env bash
dnf install -y firewalld >/dev/null
systemctl enable --now firewalld
# not immediately active after dnf install
for _i in $(seq 15); do
  firewall-cmd --state &>/dev/null && break
  sleep 1
done
firewall-cmd --permanent --remove-port="${TCP_PORT}/tcp"              2>/dev/null || true
firewall-cmd --permanent --remove-port="${UDP_START}-${UDP_END}/udp"  2>/dev/null || true
firewall-cmd --reload
