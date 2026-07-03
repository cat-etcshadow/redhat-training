#!/usr/bin/env bash
umount "$MOUNT_POINT" 2>/dev/null || true
sed -i "\\|${MOUNT_POINT}|d" /etc/fstab
rmdir "$MOUNT_POINT"
