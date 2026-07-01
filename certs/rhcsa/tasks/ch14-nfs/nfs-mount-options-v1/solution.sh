#!/usr/bin/env bash
echo "${NFS_SERVER}:${EXPORT_PATH}  ${MOUNT_POINT}  nfs  ro,noatime,rsize=${RSIZE},wsize=${WSIZE}  0 0" >> /etc/fstab
