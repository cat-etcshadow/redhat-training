#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

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

[[ $errors -eq 0 ]] && exit 0 || exit 1
