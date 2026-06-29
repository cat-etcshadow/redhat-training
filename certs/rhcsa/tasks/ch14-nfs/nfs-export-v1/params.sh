#!/usr/bin/env bash
DIRS=(/srv/nfs/share /srv/nfs/data /opt/nfsexport /var/nfsdata /srv/export)
CLIENTS=(192.168.1.0/24 192.168.0.0/24 10.0.0.0/8 172.16.0.0/16)

id=$(( RANDOM % ${#DIRS[@]} ))
ic=$(( RANDOM % ${#CLIENTS[@]} ))

echo "EXPORT_DIR=${DIRS[$id]}"
echo "NFS_CLIENT=${CLIENTS[$ic]}"
