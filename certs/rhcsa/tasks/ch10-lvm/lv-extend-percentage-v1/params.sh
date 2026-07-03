#!/usr/bin/env bash
VGS=(vg_pctfree vg_growfull vg_maxout)
LVS=(lv_pctfree lv_growfull lv_maxout)
MOUNTS=(/mnt/pctfree /mnt/growfull /mnt/maxout)
i=$(( RANDOM % ${#VGS[@]} ))
echo "VG_NAME=${VGS[$i]}"
echo "LV_NAME=${LVS[$i]}"
echo "MOUNT_POINT=${MOUNTS[$i]}"
