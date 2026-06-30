#!/usr/bin/env bash
VGS=(vg_e4app vg_e4ops vg_e4db vg_e4web)
LVS=(lv_e4app lv_e4ops lv_e4db lv_e4web)
EXTEND_MBS=(200 300 400)
MOUNTS=(/mnt/e4app /mnt/e4ops /mnt/e4db /mnt/e4web)

iv=$(( RANDOM % ${#VGS[@]} ))
il=$(( RANDOM % ${#LVS[@]} ))
ie=$(( RANDOM % ${#EXTEND_MBS[@]} ))
im=$(( RANDOM % ${#MOUNTS[@]} ))

EXTEND_MB=${EXTEND_MBS[$ie]}
echo "VG_NAME=${VGS[$iv]}"
echo "LV_NAME=${LVS[$il]}"
echo "EXTEND_BY=${EXTEND_MB}M"
echo "EXTEND_MB=$EXTEND_MB"
echo "EXTEND_MIN=$(( 400 + EXTEND_MB - 10 ))"
echo "MOUNT_POINT=${MOUNTS[$im]}"
