#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d "$MOUNT_POINT" ]] || fail "$MOUNT_POINT directory does not exist"

entry=$(grep -F "${NFS_SERVER}:${EXPORT_PATH}" /etc/fstab || true)
[[ -n "$entry" ]] || fail "no fstab entry for ${NFS_SERVER}:${EXPORT_PATH}"

echo "$entry" | grep -q "$MOUNT_POINT" || fail "fstab entry does not mount to $MOUNT_POINT"
echo "$entry" | grep -qw "ro"         || fail "fstab entry is missing the 'ro' option"
echo "$entry" | grep -qw "noatime"    || fail "fstab entry is missing the 'noatime' option"
echo "$entry" | grep -q "rsize=${RSIZE}" || fail "fstab entry missing rsize=${RSIZE}"
echo "$entry" | grep -q "wsize=${WSIZE}" || fail "fstab entry missing wsize=${WSIZE}"

[[ $errors -eq 0 ]] && exit 0 || exit 1
