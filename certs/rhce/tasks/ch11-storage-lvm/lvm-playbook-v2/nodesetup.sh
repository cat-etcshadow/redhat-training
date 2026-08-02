#!/usr/bin/env bash
set -euo pipefail
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) {print $1; exit}}')
[[ -n "$DISK" ]] || { echo "ERROR: no task disk found matching ${TASK_DISK_SIZE_GB}GiB"; exit 1; }

# Wipe any leftover VG from a previous run of this task on a reused disk
# volume (disk volumes are keyed by task+node, not per-session).
for _vg in $(pvs --noheadings -o vg_name "$DISK" 2>/dev/null); do
  for _lv in /dev/"$_vg"/*; do umount -f "$_lv" 2>/dev/null || true; done
  vgremove -y "$_vg" 2>/dev/null || true
done
pvremove -ff -y "$DISK" 2>/dev/null || true
wipefs -af "$DISK" 2>/dev/null || true
udevadm settle

pvcreate -ff -y "$DISK"
vgcreate "$VG_NAME" "$DISK"
# No rescue path in this task — leave the VG with ample free space so the
# real lvol/filesystem/mount tasks all succeed on the first attempt
# regardless of which random LV_SIZE (500m/800m/1g) was picked.
