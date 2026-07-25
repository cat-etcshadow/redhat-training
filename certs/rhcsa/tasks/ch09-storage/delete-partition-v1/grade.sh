#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
[[ -n "$DISK" ]] || fail "could not find the task's extra disk"

part_count=$(lsblk -ndo NAME "$DISK" 2>/dev/null | tail -n +2 | wc -l)
[[ "$part_count" -eq 1 ]] \
  || fail "expected exactly 1 partition remaining on the disk, found $part_count"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "ext4" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected ext4"

[[ -f "$MOUNT_POINT/marker.txt" ]] \
  || fail "$MOUNT_POINT/marker.txt is missing — data on the remaining partition was lost"
grep -q "important data" "$MOUNT_POINT/marker.txt" 2>/dev/null \
  || fail "$MOUNT_POINT/marker.txt content does not match the original data"

[[ $errors -eq 0 ]] && exit 0 || exit 1
