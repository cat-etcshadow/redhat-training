#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary xfs 1MiB "$PART_SIZE"
udevadm settle
PART="${DISK}1"
mkfs.xfs -L "$FS_LABEL" "$PART"
mkdir -p "$MOUNT_POINT"
echo "LABEL=$FS_LABEL  $MOUNT_POINT  xfs  defaults  0 0" >> /etc/fstab
mount -a
