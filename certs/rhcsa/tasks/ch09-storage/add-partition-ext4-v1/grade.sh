#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

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
[[ "$fstype" == "ext4" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected ext4"

uuid=$(findmnt -n -o UUID "$MOUNT_POINT")
grep -q "$uuid" /etc/fstab || fail "$MOUNT_POINT not in /etc/fstab by UUID"
grep "$uuid" /etc/fstab | grep -q 'noatime' \
  || fail "noatime option missing from /etc/fstab entry for $MOUNT_POINT"

[[ $errors -eq 0 ]] && exit 0 || exit 1
