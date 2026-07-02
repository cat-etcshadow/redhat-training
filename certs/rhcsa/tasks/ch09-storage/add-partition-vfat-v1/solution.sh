#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
parted "$DISK" --script mklabel msdos
parted "$DISK" --script mkpart primary fat32 1MiB 100%
udevadm settle
PART="${DISK}1"
mkfs.vfat -F 32 "$PART"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -o value -s UUID "$PART")
echo "UUID=${UUID}  ${MOUNT_POINT}  vfat  defaults  0  0" >> /etc/fstab
mount -a
