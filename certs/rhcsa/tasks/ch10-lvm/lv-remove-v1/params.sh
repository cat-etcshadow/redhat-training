#!/usr/bin/env bash
VGS=(vg_decom vg_retire vg_cleanup)
i=$(( RANDOM % ${#VGS[@]} ))
echo "VG_NAME=${VGS[$i]}"
echo "LV_KEEP=lv_keep"
echo "LV_REMOVE=lv_old"
echo "MOUNT_KEEP=/mnt/keep_${VGS[$i]}"
echo "MOUNT_REMOVE=/mnt/old_${VGS[$i]}"
