#!/usr/bin/env bash
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
UUID=$(blkid -s UUID -o value "${DISK}1")
echo "UUID=$UUID  $MOUNT_POINT  ext4  defaults,${REQUIRED_OPTS}  0 0" >> /etc/fstab
mount -a
