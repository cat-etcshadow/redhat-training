#!/usr/bin/env bash
dnf install -y tuned
systemctl enable --now tuned
tuned-adm profile throughput-performance
