#!/usr/bin/env bash
dnf install -y firewalld &>/dev/null
systemctl enable --now firewalld
# not immediately active after dnf install
for _i in $(seq 15); do
  firewall-cmd --state &>/dev/null && break
  sleep 1
done
firewall-cmd --zone=public --remove-service=ftp &>/dev/null || true
firewall-cmd --permanent --zone=public --remove-service=ftp &>/dev/null || true
firewall-cmd --zone=public --remove-service=smtp &>/dev/null || true
firewall-cmd --permanent --zone=public --remove-service=smtp &>/dev/null || true
firewall-cmd --reload &>/dev/null
