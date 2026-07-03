#!/usr/bin/env bash
EXPORTS=(/exports/legacy /exports/oldapp /exports/retired)
MOUNTS=(/mnt/old-nfs1 /mnt/old-nfs2 /mnt/old-nfs3)
i=$(( RANDOM % ${#EXPORTS[@]} ))
echo "NFS_SERVER=old-nfs.example.com"
echo "EXPORT_PATH=${EXPORTS[$i]}"
echo "MOUNT_POINT=${MOUNTS[$i]}"
