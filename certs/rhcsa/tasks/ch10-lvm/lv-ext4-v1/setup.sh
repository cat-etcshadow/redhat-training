#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }
for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; swapoff "$_p" 2>/dev/null || true; done
pvs --noheadings -o vg_name "$DISK" 2>/dev/null | awk '{print $1}' | while read -r _vg; do
  [[ -n "$_vg" ]] && { for _lv in /dev/"$_vg"/*; do umount -f "$_lv" 2>/dev/null || true; done; vgremove -y "$_vg" 2>/dev/null || true; }
done
for _mp in /mnt/e4data /mnt/e4store /mnt/e4files /mnt/e4vol \
           /mnt/app /mnt/data /mnt/ops /mnt/web "${MOUNT_POINT:-}"; do
  [[ -z "$_mp" ]] && continue
  umount -f "$_mp" 2>/dev/null || true
  sed -i "\\|${_mp}|d" /etc/fstab 2>/dev/null || true
done
sed -i "\\|${DISK}|d" /etc/fstab
pvremove -ff -y "$DISK" 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
udevadm settle   # let LVM/udev catch up with the wipe before (re)creating on this disk
