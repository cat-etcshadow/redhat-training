#!/usr/bin/env bash
# Dedicated pool for XFS partition mount points (no overlap with ext4/LVM pools)
MOUNTS=(/mnt/data /mnt/archive /mnt/files /mnt/content)
SIZES=(1GiB 800MiB 1.5GiB 2GiB)
im=$(( RANDOM % ${#MOUNTS[@]} ))
is=$(( RANDOM % ${#SIZES[@]} ))
echo "MOUNT_POINT=${MOUNTS[$im]}"
echo "PART_SIZE=${SIZES[$is]}"
