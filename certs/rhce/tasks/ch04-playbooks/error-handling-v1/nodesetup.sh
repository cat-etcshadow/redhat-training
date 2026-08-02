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
vgcreate research "$DISK"

# Leave exactly 1000 MiB free — strictly between FALLBACK_SIZE (800m) and
# LV_SIZE (1200m) — so the student's real "block:" lvol task (which always
# attempts LV_SIZE first, per the task's solution) deterministically fails
# and the real "rescue:" section deterministically runs and succeeds at
# FALLBACK_SIZE. This is what makes the rescue path an actually-exercised,
# gradeable behavior instead of dead code the playbook merely mentions.
FREE_MIB=$(vgs --noheadings --units m --nosuffix -o vg_free research | tr -d ' ')
FREE_MIB=${FREE_MIB%.*}
TARGET_FREE=1000
FILLER=$(( FREE_MIB - TARGET_FREE ))
if [[ $FILLER -gt 0 ]]; then
  lvcreate -y -L "${FILLER}M" -n filler research
fi
