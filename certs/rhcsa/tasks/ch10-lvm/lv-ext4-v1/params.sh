#!/usr/bin/env bash
# Pool separate from create-lv-v1 (vg_data/lv_data /mnt/data, vg_web/lv_web, etc.)
VG_NAMES=(vg_ext4 vg_store vg_files)
LV_NAMES=(lv_ext4 lv_store lv_files)
LV_SIZES=(300 400 500 600)
MOUNT_POINTS=(/mnt/e4data /mnt/e4store /mnt/e4files /mnt/e4vol)

iv=$(( RANDOM % ${#VG_NAMES[@]} ))
il=$(( RANDOM % ${#LV_SIZES[@]} ))
im=$(( RANDOM % ${#MOUNT_POINTS[@]} ))

echo "VG_NAME=${VG_NAMES[$iv]}"
echo "LV_NAME=${LV_NAMES[$iv]}"
echo "LV_SIZE=${LV_SIZES[$il]}M"
echo "LV_SIZE_MB=${LV_SIZES[$il]}"
echo "MOUNT_POINT=${MOUNT_POINTS[$im]}"
