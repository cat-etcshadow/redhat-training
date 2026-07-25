#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

# Check label exists on a block device
blkid | grep -q "LABEL=\"${FS_LABEL}\"" \
  || fail "No block device found with XFS label '$FS_LABEL'"

# Check fstab uses LABEL= (not UUID or device path)
grep -q "^LABEL=${FS_LABEL}" /etc/fstab \
  || fail "/etc/fstab does not have a LABEL=${FS_LABEL} entry (must use LABEL=, not UUID)"

# Check it's mounted at the expected mount point
grep -q "^LABEL=${FS_LABEL}.*${MOUNT_POINT}" /etc/fstab \
  || fail "/etc/fstab LABEL=${FS_LABEL} entry does not mount at ${MOUNT_POINT}"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not currently mounted"

fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT" 2>/dev/null)
[[ "$fstype" == "xfs" ]] || fail "$MOUNT_POINT is mounted as '$fstype', expected 'xfs'"

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

[[ $errors -eq 0 ]] && exit 0 || exit 1
