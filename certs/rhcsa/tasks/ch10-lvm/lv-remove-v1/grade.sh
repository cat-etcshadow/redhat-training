#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

vgs "$VG_NAME" &>/dev/null || fail "volume group $VG_NAME does not exist"

lvs "$VG_NAME/$LV_REMOVE" &>/dev/null \
  && fail "$LV_REMOVE still exists in $VG_NAME"

mountpoint -q "$MOUNT_REMOVE" \
  && fail "$MOUNT_REMOVE is still mounted"

grep -q "$MOUNT_REMOVE" /etc/fstab \
  && fail "$MOUNT_REMOVE entry is still present in /etc/fstab"

lvs "$VG_NAME/$LV_KEEP" &>/dev/null || fail "$LV_KEEP is missing from $VG_NAME"
mountpoint -q "$MOUNT_KEEP" || fail "$MOUNT_KEEP is not mounted"
[[ -f "$MOUNT_KEEP/marker.txt" ]] \
  || fail "data on $LV_KEEP appears to have been lost"

[[ $errors -eq 0 ]] && exit 0 || exit 1
