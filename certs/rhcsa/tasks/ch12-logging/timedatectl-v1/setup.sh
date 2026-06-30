#!/usr/bin/env bash
dnf install -y chrony &>/dev/null
timedatectl set-timezone UTC
systemctl disable --now chronyd 2>/dev/null || true
