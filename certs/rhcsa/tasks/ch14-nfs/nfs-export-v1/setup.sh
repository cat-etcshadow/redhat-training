#!/usr/bin/env bash
dnf install -y nfs-utils &>/dev/null
rm -rf "$EXPORT_DIR"
# Remove any existing exports for this dir
sed -i "\\|${EXPORT_DIR}|d" /etc/exports 2>/dev/null || true
exportfs -r 2>/dev/null || true
