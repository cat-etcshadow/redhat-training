#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
parted "$DISK" --script mklabel msdos
parted "$DISK" --script mkpart primary fat32 1MiB 100%
udevadm settle
PART="${DISK}1"
mkfs.vfat -F 32 "$PART"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -o value -s UUID "$PART")
echo "UUID=${UUID}  ${MOUNT_POINT}  vfat  defaults  0  0" >> /etc/fstab
mount -a
