#!/usr/bin/env bash
# investigate:
# mount -a
# blkid
# grep appdata /etc/fstab
sed -i '/\/mnt\/appdata/ s/ext4/xfs/' /etc/fstab
mount -a
