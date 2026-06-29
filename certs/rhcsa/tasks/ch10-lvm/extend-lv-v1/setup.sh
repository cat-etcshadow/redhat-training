#!/usr/bin/env bash
udevadm settle
DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }
for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; swapoff "$_p" 2>/dev/null || true; done
pvs --noheadings -o vg_name "$DISK" 2>/dev/null | awk '{print $1}' | while read -r _vg; do
  [[ -n "$_vg" ]] && { for _lv in /dev/"$_vg"/*; do umount -f "$_lv" 2>/dev/null || true; done; vgremove -y "$_vg" 2>/dev/null || true; }
done
for _mp in /mnt/fixme /mnt/backup /mnt/data /mnt/app /mnt/storage \
           /mnt/ops /mnt/web /mnt/store /mnt/lvm /mnt/dbstore "${MOUNT_POINT:-}"; do
  [[ -z "$_mp" ]] && continue
  umount -f "$_mp" 2>/dev/null || true
  sed -i "\\|${_mp}|d" /etc/fstab 2>/dev/null || true
done
sed -i "\\|${DISK}|d" /etc/fstab
pvremove -ff -y "$DISK" 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
pvcreate "$DISK"
vgcreate "$VG_NAME" "$DISK"
lvcreate -L 400M -n "$LV_NAME" "$VG_NAME"
mkfs.xfs "/dev/$VG_NAME/$LV_NAME"
mkdir -p "$MOUNT_POINT"
UUID=$(blkid -s UUID -o value "/dev/$VG_NAME/$LV_NAME")
echo "UUID=$UUID  $MOUNT_POINT  xfs  defaults  0 0" >> /etc/fstab
mount -a
