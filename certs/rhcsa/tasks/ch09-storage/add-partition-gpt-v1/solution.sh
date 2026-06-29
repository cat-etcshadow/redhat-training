#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
parted "$DISK" --script mklabel gpt
parted "$DISK" --script mkpart primary xfs 1MiB 100%
udevadm settle
PART="${DISK}1"
mkfs.xfs -f "$PART"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -o value -s UUID "$PART")
echo "UUID=${UUID}  ${MOUNT_POINT}  xfs  defaults  0  2" >> /etc/fstab
mount -a
