#!/usr/bin/env bash
dnf install -y firewalld &>/dev/null
systemctl enable --now firewalld
firewall-cmd --zone=public --remove-service=ftp &>/dev/null || true
firewall-cmd --permanent --zone=public --remove-service=ftp &>/dev/null || true
firewall-cmd --zone=public --remove-service=smtp &>/dev/null || true
firewall-cmd --permanent --zone=public --remove-service=smtp &>/dev/null || true
firewall-cmd --reload &>/dev/null
