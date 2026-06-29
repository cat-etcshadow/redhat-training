#!/usr/bin/env bash
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | grep -v sda | head -1)
pvcreate "$DISK"
vgcreate vg_data "$DISK"
lvcreate -L 500M -n lv_storage vg_data
mkfs.xfs /dev/vg_data/lv_storage
mkdir -p /mnt/storage
UUID=$(blkid -s UUID -o value /dev/vg_data/lv_storage)
echo "UUID=$UUID  /mnt/storage  xfs  defaults  0 0" >> /etc/fstab
mount -a
