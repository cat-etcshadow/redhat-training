#!/usr/bin/env bash
set -euo pipefail
udevadm settle
DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_MIB" '$2=="disk"{mib=int(($3+524288)/1048576); if (mib==want) {print $1; exit}}')
[[ -n "$DISK" ]] || { echo "ERROR: no task disk found matching ${TASK_DISK_SIZE_MIB}MiB"; exit 1; }

# Wipe any leftover partition/filesystem from a previous run of this task on
# a reused disk volume (disk volumes are keyed by task+node, not per-session)
# — leave it completely raw/unpartitioned for the student's own parted task.
for _p in "${DISK}"?*; do umount -f "$_p" 2>/dev/null || true; done
wipefs -af "$DISK" 2>/dev/null || true
dd if=/dev/zero of="$DISK" bs=1M count=10 2>/dev/null || true
udevadm settle
