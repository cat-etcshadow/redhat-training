#!/usr/bin/env bash
dnf install -y nfs-utils &>/dev/null
mkdir -p "$EXPORT_DIR"
echo "$EXPORT_DIR $NFS_CLIENT(rw,sync,no_root_squash)" >> /etc/exports
systemctl enable --now nfs-server
exportfs -r
