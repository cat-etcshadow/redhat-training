#!/usr/bin/env bash
MOUNTS=(/mnt/keepdata /mnt/preserved /mnt/staydata /mnt/mustkeep)
i=$(( RANDOM % ${#MOUNTS[@]} ))
echo "MOUNT_POINT=${MOUNTS[$i]}"
