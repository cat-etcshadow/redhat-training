#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
parted "$DISK" --script mklabel gpt
parted "$DISK" --script mkpart primary xfs 1MiB 100%
udevadm settle
PART="${DISK}1"
mkfs.xfs -f "$PART"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -o value -s UUID "$PART")
echo "UUID=${UUID}  ${MOUNT_POINT}  xfs  defaults  0  2" >> /etc/fstab
mount -a
