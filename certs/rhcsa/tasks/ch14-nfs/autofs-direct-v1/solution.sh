#!/usr/bin/env bash
echo "/-  /etc/auto.direct" > /etc/auto.master.d/direct.autofs
echo "${MOUNT_PATH}  ${NFS_SERVER}:${EXPORT_PATH}" > /etc/auto.direct

systemctl enable --now autofs
systemctl restart autofs
