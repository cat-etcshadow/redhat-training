#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "ext4" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected ext4"

uuid=$(findmnt -n -o UUID "$MOUNT_POINT")
grep -q "$uuid" /etc/fstab || fail "$MOUNT_POINT not in /etc/fstab by UUID"
grep "$uuid" /etc/fstab | grep -q 'noatime' \
  || fail "noatime option missing from /etc/fstab entry for $MOUNT_POINT"

[[ $errors -eq 0 ]] && exit 0 || exit 1
