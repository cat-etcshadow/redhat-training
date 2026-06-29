#!/usr/bin/env bash
dnf install -y nfs-utils
mkdir -p /mnt/nfsshare
echo "nfsserver.example.com:/exports/shared  /mnt/nfsshare  nfs  nfsvers=4,soft,timeo=30  0 0" >> /etc/fstab
# mount -a  # skipped: NFS server not available in lab
