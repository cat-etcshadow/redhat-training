#!/usr/bin/env bash
VGS=(vg_legacy vg_migrate vg_old)
OLD_LVS=(lv_old lv_legacy lv_temp)
NEW_LVS=(lv_current lv_new lv_final)
MOUNTS=(/mnt/legacydata /mnt/migratedata /mnt/olddata)

i=$(( RANDOM % ${#VGS[@]} ))

echo "VG_NAME=${VGS[$i]}"
echo "OLD_LV_NAME=${OLD_LVS[$i]}"
echo "NEW_LV_NAME=${NEW_LVS[$i]}"
echo "MOUNT_POINT=${MOUNTS[$i]}"
