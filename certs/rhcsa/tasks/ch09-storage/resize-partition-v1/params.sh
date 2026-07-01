#!/usr/bin/env bash
MOUNTS=(/mnt/growable /mnt/expand-me /mnt/scaleup)
im=$(( RANDOM % ${#MOUNTS[@]} ))
echo "MOUNT_POINT=${MOUNTS[$im]}"
