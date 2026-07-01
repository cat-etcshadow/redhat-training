#!/usr/bin/env bash
umount "$MOUNT_POINT"
lvrename "$VG_NAME" "$OLD_LV_NAME" "$NEW_LV_NAME"
sed -i "s|/dev/${VG_NAME}/${OLD_LV_NAME}|/dev/${VG_NAME}/${NEW_LV_NAME}|" /etc/fstab
mount -a
