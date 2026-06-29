#!/usr/bin/env bash
MOUNTS=(/mnt/gpt_data /mnt/gpt_store /mnt/gpt_vol /mnt/gpt_share)
SIZES=(500M 1G 750M 250M)
idx=$(( RANDOM % ${#MOUNTS[@]} ))
echo "MOUNT_POINT=${MOUNTS[$idx]}"
echo "PART_SIZE=${SIZES[$idx]}"
