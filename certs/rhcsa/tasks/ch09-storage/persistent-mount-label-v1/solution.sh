#!/usr/bin/env bash
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary xfs 1MiB "$PART_SIZE"
udevadm settle
PART="${DISK}1"
mkfs.xfs -L "$FS_LABEL" "$PART"
mkdir -p "$MOUNT_POINT"
echo "LABEL=$FS_LABEL  $MOUNT_POINT  xfs  defaults  0 0" >> /etc/fstab
mount -a
