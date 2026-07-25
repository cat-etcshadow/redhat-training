#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

DISK=$(lsblk -dpbno NAME,TYPE,SIZE | awk -v want="$TASK_DISK_SIZE_GB" '$2=="disk"{gib=int(($3+536870912)/1073741824); if (gib==want) print $1}')
[[ -n "$DISK" ]] || fail "no extra disk found"

# must have GPT partition table
pttype=$(blkid -o value -s PTTYPE "$DISK" 2>/dev/null || parted "$DISK" print 2>/dev/null | awk '/Partition Table/{print $3}')
echo "$pttype" | grep -qi 'gpt' \
  || fail "disk $DISK does not have a GPT partition table (found: $pttype)"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

# size check (±20% tolerance covers partition alignment and MiB/MB ambiguity)
size_to_bytes() {
  local num unit mult=1
  num=$(grep -oE '^[0-9.]+' <<<"$1"); unit=$(grep -oE '[A-Za-z]+$' <<<"$1")
  case "$unit" in GiB|G) mult=1073741824;; MiB|M) mult=1048576;; KiB|K) mult=1024;; esac
  awk -v n="$num" -v m="$mult" 'BEGIN{printf "%d", n*m}'
}
want=$(size_to_bytes "$PART_SIZE")
actual=$(lsblk -bno SIZE "$(findmnt -n -o SOURCE "$MOUNT_POINT")" 2>/dev/null | head -1)
if [[ -n "$actual" ]]; then
  (( actual >= want*80/100 && actual <= want*120/100 )) \
    || fail "$MOUNT_POINT size ${actual}B is not close to requested $PART_SIZE"
fi

fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "xfs" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected xfs"

uuid=$(findmnt -n -o UUID "$MOUNT_POINT")
grep -q "$uuid" /etc/fstab \
  || fail "$MOUNT_POINT not in /etc/fstab by UUID (found UUID=$uuid)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
