#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$REPORT_FILE" ]] || fail "$REPORT_FILE does not exist"
grep -qF "$EXPORT_DIR" "$REPORT_FILE" \
  || fail "$REPORT_FILE does not show the export $EXPORT_DIR (run: showmount -e localhost)"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fstype=$(findmnt -no FSTYPE "$MOUNT_POINT")
[[ "$fstype" == nfs* ]] || fail "$MOUNT_POINT filesystem is '$fstype', expected an NFS mount"

[[ -f "${MOUNT_POINT}/readme.txt" ]] \
  || fail "readme.txt not visible at $MOUNT_POINT — wrong export mounted?"

[[ $errors -eq 0 ]] && exit 0 || exit 1
