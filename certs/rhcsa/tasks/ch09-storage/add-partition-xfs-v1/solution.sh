#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
echo -e "n\np\n1\n\n+1G\nw" | fdisk "$DISK"
partprobe "$DISK"
mkfs.xfs "${DISK}1"
mkdir -p /mnt/data
UUID=$(blkid -s UUID -o value "${DISK}1")
echo "UUID=$UUID  /mnt/data  xfs  defaults  0 0" >> /etc/fstab
mount -a
