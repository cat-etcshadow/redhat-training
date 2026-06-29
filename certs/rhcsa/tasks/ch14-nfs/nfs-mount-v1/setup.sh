#!/usr/bin/env bash
dnf install -y nfs-utils &>/dev/null
sed -i '/\/mnt\/nfsshare/d' /etc/fstab
umount /mnt/nfsshare 2>/dev/null || true
rm -rf /mnt/nfsshare
