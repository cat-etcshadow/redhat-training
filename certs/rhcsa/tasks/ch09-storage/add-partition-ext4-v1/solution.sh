#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
echo -e "n\np\n1\n\n+800M\nw" | fdisk "$DISK"
partprobe "$DISK"
mkfs.ext4 "${DISK}1"
mkdir -p /mnt/backup
UUID=$(blkid -s UUID -o value "${DISK}1")
echo "UUID=$UUID  /mnt/backup  ext4  defaults,noatime  0 2" >> /etc/fstab
mount -a
