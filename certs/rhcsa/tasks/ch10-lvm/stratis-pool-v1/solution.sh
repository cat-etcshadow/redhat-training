#!/usr/bin/env bash
dnf install -y stratisd stratis-cli &>/dev/null
systemctl enable --now stratisd
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
stratis pool create "$POOL_NAME" "$DISK"
stratis filesystem create "$POOL_NAME" "$FS_NAME"
mkdir -p "$MOUNT_POINT"
UUID=$(lsblk -o UUID -n "/dev/stratis/${POOL_NAME}/${FS_NAME}")
echo "UUID=${UUID}  ${MOUNT_POINT}  xfs  defaults,x-systemd.requires=stratisd.service  0  0" >> /etc/fstab
mount -a
