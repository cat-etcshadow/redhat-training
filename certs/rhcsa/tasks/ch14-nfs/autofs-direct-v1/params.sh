#!/usr/bin/env bash
MOUNT_PATHS=(/mnt/direct-data /mnt/direct-assets /mnt/direct-media)
EXPORTS=(/exports/direct-data /exports/direct-assets /exports/direct-media)

i=$(( RANDOM % ${#MOUNT_PATHS[@]} ))

echo "NFS_SERVER=nfsserver.example.com"
echo "MOUNT_PATH=${MOUNT_PATHS[$i]}"
echo "EXPORT_PATH=${EXPORTS[$i]}"
