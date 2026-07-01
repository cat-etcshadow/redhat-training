#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

lvs "$VG_NAME/$NEW_LV_NAME" &>/dev/null \
  || fail "$NEW_LV_NAME does not exist in $VG_NAME"
lvs "$VG_NAME/$OLD_LV_NAME" &>/dev/null \
  && fail "$OLD_LV_NAME still exists in $VG_NAME — it should have been renamed"

grep -q "$OLD_LV_NAME" /etc/fstab \
  && fail "/etc/fstab still references the old LV name $OLD_LV_NAME"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fstype=$(findmnt -no FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "xfs" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected xfs"

[[ -f "${MOUNT_POINT}/data.txt" ]] \
  || fail "data.txt is missing from $MOUNT_POINT — data was lost during the rename"

[[ $errors -eq 0 ]] && exit 0 || exit 1
