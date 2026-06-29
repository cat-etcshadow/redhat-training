#!/usr/bin/env bash
dnf install -y autofs nfs-utils &>/dev/null
systemctl disable --now autofs 2>/dev/null || true
rm -f /etc/auto.master.d/homes.autofs /etc/auto.homes
systemctl daemon-reload
