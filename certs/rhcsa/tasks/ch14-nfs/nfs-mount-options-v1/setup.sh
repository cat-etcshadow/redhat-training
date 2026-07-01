#!/usr/bin/env bash
dnf install -y nfs-utils &>/dev/null
sed -i "\\|${MOUNT_POINT}|d" /etc/fstab
umount "$MOUNT_POINT" 2>/dev/null || true
rm -rf "$MOUNT_POINT"
mkdir -p "$MOUNT_POINT"
