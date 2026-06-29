#!/usr/bin/env bash
VGS=(vg_data vg_app vg_ops vg_store vg_web)
LVS=(lv_storage lv_app lv_data lv_vol lv_media)
SIZES=(300 400 500 600 750)
# Dedicated LVM mount point pool
MOUNTS=(/mnt/storage /mnt/lvm /mnt/dbstore /mnt/appdata /mnt/vol1)

iv=$(( RANDOM % ${#VGS[@]} ))
il=$(( RANDOM % ${#LVS[@]} ))
is=$(( RANDOM % ${#SIZES[@]} ))
im=$(( RANDOM % ${#MOUNTS[@]} ))

echo "VG_NAME=${VGS[$iv]}"
echo "LV_NAME=${LVS[$il]}"
echo "LV_SIZE=${SIZES[$is]}M"
echo "LV_SIZE_MB=${SIZES[$is]}"
echo "MOUNT_POINT=${MOUNTS[$im]}"
