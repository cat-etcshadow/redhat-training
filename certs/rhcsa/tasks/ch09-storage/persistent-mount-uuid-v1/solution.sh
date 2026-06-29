#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
UUID=$(blkid -s UUID -o value "${DISK}1")
sed -i "s|${DISK}1|UUID=$UUID|" /etc/fstab
mount -a
