#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }
for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; swapoff "$_p" 2>/dev/null || true; done
pvs --noheadings -o vg_name "$DISK" 2>/dev/null | awk '{print $1}' | while read -r _vg; do
  [[ -n "$_vg" ]] && { for _lv in /dev/"$_vg"/*; do umount -f "$_lv" 2>/dev/null || true; done; vgremove -y "$_vg" 2>/dev/null || true; }
done
for _mp in /mnt/fixme /mnt/backup /mnt/data /mnt/app /mnt/storage \
           /mnt/keepdata /mnt/preserved /mnt/staydata /mnt/mustkeep "${MOUNT_POINT:-}"; do
  [[ -z "$_mp" ]] && continue
  umount -f "$_mp" 2>/dev/null || true
  sed -i "\\|${_mp}|d" /etc/fstab 2>/dev/null || true
done
sed -i "\\|${DISK}|d" /etc/fstab
pvremove -ff -y "$DISK" 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
udevadm settle

# partition 1: small, unused, "created by mistake"
# partition 2: the real one, ext4, mounted persistently at MOUNT_POINT
echo -e "n\np\n1\n\n+200M\nn\np\n2\n\n+800M\nw" | fdisk "$DISK" &>/dev/null
partprobe "$DISK"
udevadm settle
mkfs.ext4 -F "${DISK}2" &>/dev/null
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -s UUID -o value "${DISK}2")
echo "UUID=$UUID  $MOUNT_POINT  ext4  defaults  0 0" >> /etc/fstab
mount -a
echo "important data - do not lose" > "$MOUNT_POINT/marker.txt"
