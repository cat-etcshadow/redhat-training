#!/usr/bin/env bash
# Disjoint from create-lv-v1's and extend-lv-v1's VG_NAME pools — VG names
# are global, so a shared value would make one task's vgcreate collide with
# another's even though each runs on its own dedicated disk.
VG_NAMES=(vg_ext4 vg_e4store vg_files)
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
