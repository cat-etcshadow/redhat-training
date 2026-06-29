#!/usr/bin/env bash
dnf install -y tuned &>/dev/null
systemctl enable --now tuned &>/dev/null
tuned-adm profile balanced
