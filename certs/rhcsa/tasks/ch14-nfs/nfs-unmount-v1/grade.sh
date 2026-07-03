#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mountpoint -q "$MOUNT_POINT" 2>/dev/null && fail "$MOUNT_POINT is still mounted"

grep -q "$MOUNT_POINT" /etc/fstab \
  && fail "/etc/fstab still contains an entry for $MOUNT_POINT"

[[ -d "$MOUNT_POINT" ]] \
  && fail "$MOUNT_POINT directory still exists"

[[ $errors -eq 0 ]] && exit 0 || exit 1
