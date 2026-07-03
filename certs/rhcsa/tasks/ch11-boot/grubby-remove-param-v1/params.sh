#!/usr/bin/env bash
# Safe, no-op kernel params (don't alter real boot behavior)
PARAMS=("numa=off" "mitigations=off" "nohz=off" "nosmt" "scsi_mod.use_blk_mq=y")
ip=$(( RANDOM % ${#PARAMS[@]} ))
echo "KERNEL_PARAM=${PARAMS[$ip]}"
