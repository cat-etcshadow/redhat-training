#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }
for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; done
for _mp in /mnt/datastore /mnt/datasets /mnt/rawdata /mnt/records \
           /mnt/data /mnt/archive /mnt/files /mnt/content \
           /mnt/backup /mnt/cache /mnt/logs /mnt/temp "${MOUNT_POINT:-}"; do
  [[ -z "$_mp" ]] && continue
  umount -f "$_mp" 2>/dev/null || true
  sed -i "\\|${_mp}|d" /etc/fstab 2>/dev/null || true
done
sed -i "\\|LABEL=${FS_LABEL}|d" /etc/fstab 2>/dev/null || true
sed -i "\\|${DISK}|d" /etc/fstab
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
udevadm settle   # let LVM/udev catch up with the wipe before (re)creating on this disk
