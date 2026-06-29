#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "vfat" ]] || fail "$MOUNT_POINT filesystem is '$fstype', expected 'vfat'"

uuid=$(findmnt -n -o UUID "$MOUNT_POINT")
grep -q "$uuid" /etc/fstab \
  || fail "$MOUNT_POINT UUID $uuid not found in /etc/fstab (not persistent)"

# fstab entry must specify vfat
grep "$uuid" /etc/fstab | grep -qi 'vfat' \
  || fail "fstab entry for $MOUNT_POINT does not specify vfat filesystem type"

[[ $errors -eq 0 ]] && exit 0 || exit 1
