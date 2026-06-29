#!/usr/bin/env bash
POOLS=(pool_data pool_apps pool_media pool_logs)
FSS=(fs_main fs_app fs_content fs_journal)
MOUNTS=(/mnt/stratis_data /mnt/stratis_apps /mnt/stratis_media /mnt/stratis_logs)
idx=$(( RANDOM % ${#POOLS[@]} ))
echo "POOL_NAME=${POOLS[$idx]}"
echo "FS_NAME=${FSS[$idx]}"
echo "MOUNT_POINT=${MOUNTS[$idx]}"
