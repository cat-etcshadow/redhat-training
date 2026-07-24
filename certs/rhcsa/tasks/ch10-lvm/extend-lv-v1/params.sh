#!/usr/bin/env bash
# Disjoint from create-lv-v1's VGS pool — extend-lv-v1's setup.sh calls
# vgcreate unconditionally (it needs a pre-existing LV to extend), so a
# shared name would make create-lv-v1's own candidate-run `vgcreate` fail
# with "already exists" whenever both tasks draw the same value.
VGS=(vg_extapp vg_extops vg_extweb vg_extstore)
LVS=(lv_app lv_ops lv_web lv_data)
EXTEND_MBS=(200 300 400)
MOUNTS=(/mnt/app /mnt/ops /mnt/web /mnt/store)

iv=$(( RANDOM % ${#VGS[@]} ))
il=$(( RANDOM % ${#LVS[@]} ))
ie=$(( RANDOM % ${#EXTEND_MBS[@]} ))
im=$(( RANDOM % ${#MOUNTS[@]} ))

EXTEND_MB=${EXTEND_MBS[$ie]}
echo "VG_NAME=${VGS[$iv]}"
echo "LV_NAME=${LVS[$il]}"
echo "EXTEND_BY=${EXTEND_MB}M"
echo "EXTEND_MB=$EXTEND_MB"
# setup creates lv at 400M; grade expects >= 400+EXTEND_MB-10
echo "EXTEND_MIN=$(( 400 + EXTEND_MB - 10 ))"
echo "MOUNT_POINT=${MOUNTS[$im]}"
