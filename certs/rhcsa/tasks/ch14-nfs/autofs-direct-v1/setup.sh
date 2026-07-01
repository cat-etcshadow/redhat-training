#!/usr/bin/env bash
dnf install -y autofs nfs-utils &>/dev/null
systemctl disable --now autofs 2>/dev/null || true
rm -f /etc/auto.master.d/direct.autofs /etc/auto.direct
systemctl daemon-reload
