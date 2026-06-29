#!/usr/bin/env bash
# Separate pool from add-partition-xfs-v1 (/mnt/data, /mnt/archive, /mnt/files, /mnt/content)
MOUNT_POINTS=(/mnt/datastore /mnt/datasets /mnt/rawdata /mnt/records)
LABELS=(xfsdata xfslabel storefs datavol)
SIZES=(200 300 400 500)

im=$(( RANDOM % ${#MOUNT_POINTS[@]} ))
il=$(( RANDOM % ${#LABELS[@]} ))
is=$(( RANDOM % ${#SIZES[@]} ))

echo "MOUNT_POINT=${MOUNT_POINTS[$im]}"
echo "FS_LABEL=${LABELS[$il]}"
echo "PART_SIZE=${SIZES[$is]}MiB"
