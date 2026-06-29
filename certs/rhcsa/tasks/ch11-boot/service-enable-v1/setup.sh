#!/usr/bin/env bash
dnf install -y postfix &>/dev/null
systemctl disable --now postfix 2>/dev/null || true
