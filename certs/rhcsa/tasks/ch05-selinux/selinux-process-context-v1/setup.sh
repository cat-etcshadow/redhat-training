#!/usr/bin/env bash
dnf install -y httpd &>/dev/null
systemctl enable --now httpd &>/dev/null
rm -f "$OUTPUT_FILE"
