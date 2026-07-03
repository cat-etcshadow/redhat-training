#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d "$MOUNT_POINT" ]] || fail "$MOUNT_POINT directory does not exist"

entry=$(grep -F "${NFS_SERVER}:${EXPORT_PATH}" /etc/fstab || true)
[[ -n "$entry" ]] || fail "no fstab entry for ${NFS_SERVER}:${EXPORT_PATH}"

echo "$entry" | grep -q "$MOUNT_POINT" || fail "fstab entry does not mount to $MOUNT_POINT"
echo "$entry" | grep -qw "noauto" || fail "fstab entry is missing the noauto option"
echo "$entry" | grep -qw "x-systemd.automount" || fail "fstab entry is missing the x-systemd.automount option"

[[ $errors -eq 0 ]] && exit 0 || exit 1
