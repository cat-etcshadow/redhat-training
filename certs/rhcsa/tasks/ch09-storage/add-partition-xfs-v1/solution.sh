#!/usr/bin/env bash
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
PART_MIB=$(awk -v s="$PART_SIZE" 'BEGIN{n=s+0; if(s ~ /G/) n*=1024; printf "%d", n}')
echo -e "n\np\n1\n\n+${PART_MIB}M\nw" | fdisk "$DISK"
partprobe "$DISK"
mkfs.xfs "${DISK}1"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -s UUID -o value "${DISK}1")
echo "UUID=$UUID  $MOUNT_POINT  xfs  defaults  0 0" >> /etc/fstab
mount -a
