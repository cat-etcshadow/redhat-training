#!/usr/bin/env bash
LOOP_IMG=/var/lib/rhtr-lvremove-base.img

for ld in $(losetup -j "$LOOP_IMG" 2>/dev/null | cut -d: -f1); do
  vgs "$VG_NAME" &>/dev/null && { for _lv in /dev/"$VG_NAME"/*; do umount -f "$_lv" 2>/dev/null || true; done; vgremove -ff -y "$VG_NAME" &>/dev/null; }
  losetup -d "$ld" 2>/dev/null || true
done
vgs "$VG_NAME" &>/dev/null && { for _lv in /dev/"$VG_NAME"/*; do umount -f "$_lv" 2>/dev/null || true; done; vgremove -ff -y "$VG_NAME" &>/dev/null; }

umount -f "$MOUNT_KEEP" 2>/dev/null || true
umount -f "$MOUNT_REMOVE" 2>/dev/null || true
sed -i "\\|${MOUNT_KEEP}|d" /etc/fstab
sed -i "\\|${MOUNT_REMOVE}|d" /etc/fstab

rm -f "$LOOP_IMG"
dd if=/dev/zero of="$LOOP_IMG" bs=1M count=700 2>/dev/null
LOOP_DEV=$(losetup -f)
losetup "$LOOP_DEV" "$LOOP_IMG"

pvcreate -ff -y "$LOOP_DEV" &>/dev/null
vgcreate "$VG_NAME" "$LOOP_DEV" &>/dev/null

lvcreate -L 200M -n "$LV_KEEP" "$VG_NAME" &>/dev/null
mkfs.xfs -f "/dev/$VG_NAME/$LV_KEEP" &>/dev/null
mkdir -p "$MOUNT_KEEP"
UUID_KEEP=$(blkid -s UUID -o value "/dev/$VG_NAME/$LV_KEEP")
echo "UUID=$UUID_KEEP  $MOUNT_KEEP  xfs  defaults  0 0" >> /etc/fstab

lvcreate -L 200M -n "$LV_REMOVE" "$VG_NAME" &>/dev/null
mkfs.xfs -f "/dev/$VG_NAME/$LV_REMOVE" &>/dev/null
mkdir -p "$MOUNT_REMOVE"
UUID_REMOVE=$(blkid -s UUID -o value "/dev/$VG_NAME/$LV_REMOVE")
echo "UUID=$UUID_REMOVE  $MOUNT_REMOVE  xfs  defaults  0 0" >> /etc/fstab

mount -a
echo "important data - do not lose" > "$MOUNT_KEEP/marker.txt"
