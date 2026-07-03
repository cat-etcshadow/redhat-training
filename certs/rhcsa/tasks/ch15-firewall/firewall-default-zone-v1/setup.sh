#!/usr/bin/env bash
dnf install -y firewalld &>/dev/null
systemctl enable --now firewalld
firewall-cmd --set-default-zone=public &>/dev/null
