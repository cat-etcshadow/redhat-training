#!/usr/bin/env bash
dnf install -y nfs-utils &>/dev/null
sed -i "\\|${MOUNT_POINT}|d" /etc/fstab
umount "$MOUNT_POINT" 2>/dev/null || true
mkdir -p "$MOUNT_POINT"
echo "${NFS_SERVER}:${EXPORT_PATH}  ${MOUNT_POINT}  nfs4  defaults  0 0" >> /etc/fstab
