#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
echo -e "n\np\n1\n\n+512M\nt\n82\nw" | fdisk "$DISK"
partprobe "$DISK"
mkswap "${DISK}1"
swapon "${DISK}1"
UUID=$(blkid -s UUID -o value "${DISK}1")
echo "UUID=$UUID  swap  swap  defaults  0 0" >> /etc/fstab
