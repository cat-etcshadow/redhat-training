#!/usr/bin/env bash
EXPORTS=(/exports/readonly /exports/assets /exports/media)
MOUNTS=(/mnt/ro-share /mnt/assets /mnt/media)
SIZES=(8192 32768 65536)

i=$(( RANDOM % ${#EXPORTS[@]} ))
is=$(( RANDOM % ${#SIZES[@]} ))

echo "NFS_SERVER=nfsserver.example.com"
echo "EXPORT_PATH=${EXPORTS[$i]}"
echo "MOUNT_POINT=${MOUNTS[$i]}"
echo "RSIZE=${SIZES[$is]}"
echo "WSIZE=${SIZES[$is]}"
