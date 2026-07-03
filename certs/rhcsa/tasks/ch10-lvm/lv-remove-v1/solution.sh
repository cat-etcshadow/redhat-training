#!/usr/bin/env bash
umount "$MOUNT_REMOVE"
sed -i "\\|${MOUNT_REMOVE}|d" /etc/fstab
lvremove -y "/dev/$VG_NAME/$LV_REMOVE"
