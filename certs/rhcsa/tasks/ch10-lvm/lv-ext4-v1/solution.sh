#!/usr/bin/env bash
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
pvcreate "$DISK"
vgcreate "$VG_NAME" "$DISK"
lvcreate -L "$LV_SIZE" -n "$LV_NAME" "$VG_NAME"
mkfs.ext4 "/dev/$VG_NAME/$LV_NAME"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -s UUID -o value "/dev/$VG_NAME/$LV_NAME")
echo "UUID=$UUID  $MOUNT_POINT  ext4  defaults  0 2" >> /etc/fstab
mount -a
