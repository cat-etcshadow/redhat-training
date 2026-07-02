#!/usr/bin/env bash
LOOP_IMG=/var/lib/rhtr-vgextend-base.img

# Tear down any previous run's loop device and VG
for ld in $(losetup -j "$LOOP_IMG" 2>/dev/null | cut -d: -f1); do
  vgs "$VG_NAME" &>/dev/null && vgremove -ff -y "$VG_NAME" &>/dev/null
  losetup -d "$ld" 2>/dev/null || true
done
vgs "$VG_NAME" &>/dev/null && vgremove -ff -y "$VG_NAME" &>/dev/null

rm -f "$LOOP_IMG"
dd if=/dev/zero of="$LOOP_IMG" bs=1M count=500 2>/dev/null
LOOP_DEV=$(losetup -f)
losetup "$LOOP_DEV" "$LOOP_IMG"

pvcreate -ff -y "$LOOP_DEV" &>/dev/null
vgcreate "$VG_NAME" "$LOOP_DEV" &>/dev/null

# The real attached extra disk is the new PV the candidate must add
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
[[ -n "$DISK" ]] || { echo "ERROR: no extra disk found"; exit 1; }

for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; swapoff "$_p" 2>/dev/null || true; done
pvs --noheadings -o vg_name "$DISK" 2>/dev/null | awk -v vg="$VG_NAME" '$1!=vg{print $1}' | while read -r _vg; do
  [[ -n "$_vg" ]] && vgremove -ff -y "$_vg" 2>/dev/null || true
done
sed -i "\\|${DISK}|d" /etc/fstab
pvremove -ff -y "$DISK" 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
udevadm settle   # let LVM/udev catch up with the wipe before (re)creating on this disk
