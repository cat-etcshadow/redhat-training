#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
UUID=$(blkid -s UUID -o value "${DISK}1")
echo "UUID=$UUID  $MOUNT_POINT  ext4  defaults,${REQUIRED_OPTS}  0 0" >> /etc/fstab
mount -a
