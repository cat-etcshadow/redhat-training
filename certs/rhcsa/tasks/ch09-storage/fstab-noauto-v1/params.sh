#!/usr/bin/env bash
MOUNTS=(/mnt/usbdata /mnt/removable /mnt/extdrive)
USERS=(fielduser deskuser labuser)

im=$(( RANDOM % ${#MOUNTS[@]} ))
iu=$(( RANDOM % ${#USERS[@]} ))

echo "MOUNT_POINT=${MOUNTS[$im]}"
echo "TEST_USER=${USERS[$iu]}"
