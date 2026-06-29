#!/usr/bin/env bash
dnf install -y firewalld >/dev/null
systemctl enable --now firewalld
firewall-cmd --permanent --add-service=ssh 2>/dev/null || true
firewall-cmd --permanent --remove-rich-rule='rule family=ipv4 source address=192.168.100.0/24 service name=ssh accept' 2>/dev/null || true
firewall-cmd --permanent --remove-rich-rule='rule family=ipv4 service name=ssh reject' 2>/dev/null || true
firewall-cmd --reload
