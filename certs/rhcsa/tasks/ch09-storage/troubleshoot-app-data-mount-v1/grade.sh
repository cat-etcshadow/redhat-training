#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mountpoint -q /mnt/appdata || fail "/mnt/appdata is not mounted"
fstype=$(findmnt -n -o FSTYPE /mnt/appdata)
[[ "$fstype" == "xfs" ]] || fail "/mnt/appdata filesystem is $fstype, expected xfs"

entry=$(awk '$2=="/mnt/appdata"' /etc/fstab)
[[ -n "$entry" ]] || fail "no /etc/fstab entry for /mnt/appdata"
echo "$entry" | awk '{print $3}' | grep -qx xfs || fail "/etc/fstab entry for /mnt/appdata does not declare xfs"

[[ $errors -eq 0 ]] && exit 0 || exit 1
