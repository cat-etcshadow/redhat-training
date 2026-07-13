#!/usr/bin/env bash
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
echo -e "n\np\n1\n\n+512M\nt\n82\nw" | fdisk "$DISK"
partprobe "$DISK"
mkswap "${DISK}1"
swapon "${DISK}1"
UUID=$(blkid -s UUID -o value "${DISK}1")
echo "UUID=$UUID  swap  swap  defaults  0 0" >> /etc/fstab
