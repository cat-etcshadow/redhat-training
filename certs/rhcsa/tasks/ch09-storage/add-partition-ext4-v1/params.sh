#!/usr/bin/env bash
# Dedicated pool for ext4 partition mount points
MOUNTS=(/mnt/backup /mnt/cache /mnt/logs /mnt/temp)
SIZES=(800MiB 600MiB 1GiB 1.2GiB)
im=$(( RANDOM % ${#MOUNTS[@]} ))
is=$(( RANDOM % ${#SIZES[@]} ))
echo "MOUNT_POINT=${MOUNTS[$im]}"
echo "PART_SIZE=${SIZES[$is]}"
