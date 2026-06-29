#!/usr/bin/env bash
MOUNTS=(/mnt/usb_share /mnt/fat_data /mnt/compat /mnt/exchange)
idx=$(( RANDOM % ${#MOUNTS[@]} ))
echo "MOUNT_POINT=${MOUNTS[$idx]}"
