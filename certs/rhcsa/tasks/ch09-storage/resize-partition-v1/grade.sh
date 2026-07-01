#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fstype=$(findmnt -no FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "xfs" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected xfs"

grep -q "$MOUNT_POINT" /etc/fstab || fail "$MOUNT_POINT has no /etc/fstab entry"

size_kb=$(df --output=size -k "$MOUNT_POINT" 2>/dev/null | tail -1 | tr -d ' ')
[[ "$size_kb" -gt 2500000 ]] \
  || fail "$MOUNT_POINT is only ${size_kb}K — the partition/filesystem was not grown"

[[ $errors -eq 0 ]] && exit 0 || exit 1
