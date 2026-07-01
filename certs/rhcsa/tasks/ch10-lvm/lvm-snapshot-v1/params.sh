#!/usr/bin/env bash
VGS=(vg_prod vg_apps vg_svc)
LVS=(lv_prod lv_apps lv_svc)
SNAPS=(lv_prod_snap lv_apps_snap lv_svc_snap)
MOUNTS=(/mnt/proddata /mnt/appsdata /mnt/svcdata)

i=$(( RANDOM % ${#VGS[@]} ))

echo "VG_NAME=${VGS[$i]}"
echo "LV_NAME=${LVS[$i]}"
echo "SNAP_NAME=${SNAPS[$i]}"
echo "SNAP_SIZE=200M"
echo "MOUNT_POINT=${MOUNTS[$i]}"
