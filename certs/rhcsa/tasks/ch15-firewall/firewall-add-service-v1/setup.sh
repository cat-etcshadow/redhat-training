#!/usr/bin/env bash
dnf install -y firewalld &>/dev/null
systemctl enable --now firewalld
# not immediately active after dnf install
for _i in $(seq 15); do
  firewall-cmd --state &>/dev/null && break
  sleep 1
done
firewall-cmd --permanent --remove-service=http  2>/dev/null || true
firewall-cmd --permanent --remove-service=https 2>/dev/null || true
firewall-cmd --reload
