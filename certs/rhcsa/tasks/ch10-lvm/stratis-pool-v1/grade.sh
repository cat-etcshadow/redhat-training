#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# stratisd must be running
systemctl is-active stratisd &>/dev/null \
  || fail "stratisd is not running"

# pool must exist
stratis pool list 2>/dev/null | grep -q "$POOL_NAME" \
  || fail "Stratis pool '$POOL_NAME' does not exist"

# filesystem must exist in pool
stratis filesystem list "$POOL_NAME" 2>/dev/null | grep -q "$FS_NAME" \
  || fail "Stratis filesystem '$FS_NAME' does not exist in pool '$POOL_NAME'"

# mount point must be mounted
mountpoint -q "$MOUNT_POINT" \
  || fail "$MOUNT_POINT is not mounted"

# must be xfs
fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "xfs" ]] || fail "$MOUNT_POINT is $fstype, expected xfs"

# must be persistent in fstab
uuid=$(findmnt -n -o UUID "$MOUNT_POINT")
grep -q "$uuid" /etc/fstab \
  || fail "UUID $uuid not found in /etc/fstab (not persistent)"

# fstab must have the systemd.requires option
grep "$uuid" /etc/fstab | grep -q 'stratisd' \
  || fail "fstab entry missing 'x-systemd.requires=stratisd.service' mount option"

[[ $errors -eq 0 ]] && exit 0 || exit 1
