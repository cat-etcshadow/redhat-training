#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
pvcreate "$DISK"
vgcreate "$VG_NAME" "$DISK"
lvcreate -L "$LV_SIZE" -n "$LV_NAME" "$VG_NAME"
mkfs.ext4 "/dev/$VG_NAME/$LV_NAME"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -s UUID -o value "/dev/$VG_NAME/$LV_NAME")
echo "UUID=$UUID  $MOUNT_POINT  ext4  defaults  0 2" >> /etc/fstab
mount -a
