#!/usr/bin/env bash
EXPORT_DIRS=(/srv/nfs/discover-a /srv/nfs/discover-b /srv/nfs/discover-c)
MOUNTS=(/mnt/discovered /mnt/found-share /mnt/located-share)

i=$(( RANDOM % ${#EXPORT_DIRS[@]} ))

echo "EXPORT_DIR=${EXPORT_DIRS[$i]}"
echo "MOUNT_POINT=${MOUNTS[$i]}"
echo "REPORT_FILE=/root/showmount-output.txt"
