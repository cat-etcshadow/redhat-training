#!/usr/bin/env bash
EXPORTS=(/exports/data /exports/projects /exports/scratch)
MOUNTS=(/mnt/ondemand-data /mnt/ondemand-projects /mnt/ondemand-scratch)
i=$(( RANDOM % ${#EXPORTS[@]} ))
echo "NFS_SERVER=nfsserver.example.com"
echo "EXPORT_PATH=${EXPORTS[$i]}"
echo "MOUNT_POINT=${MOUNTS[$i]}"
