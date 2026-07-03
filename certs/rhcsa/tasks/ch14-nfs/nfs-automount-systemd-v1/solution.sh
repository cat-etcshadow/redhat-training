#!/usr/bin/env bash
echo "${NFS_SERVER}:${EXPORT_PATH}  ${MOUNT_POINT}  nfs4  noauto,x-systemd.automount,_netdev  0 0" >> /etc/fstab
systemctl daemon-reload
