#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

vgs "$VG_NAME" &>/dev/null || fail "Volume group $VG_NAME does not exist"
lvs "$VG_NAME/$LV_NAME" &>/dev/null || fail "Logical volume $LV_NAME in $VG_NAME does not exist"

lv_size=$(lvs --noheadings -o lv_size --units m "$VG_NAME/$LV_NAME" 2>/dev/null | tr -d ' m')
min_mb=$(( LV_SIZE_MB - 10 ))
python3 -c "exit(0 if float('${lv_size}') >= ${min_mb} else 1)" \
  || fail "$LV_NAME size is ${lv_size}m, expected ~${LV_SIZE_MB}m"

fstype=$(blkid -s TYPE -o value "/dev/$VG_NAME/$LV_NAME" 2>/dev/null)
[[ "$fstype" == "ext4" ]] || fail "/dev/$VG_NAME/$LV_NAME is $fstype, expected ext4"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

grep -q "$MOUNT_POINT" /etc/fstab || fail "$MOUNT_POINT has no /etc/fstab entry"

[[ $errors -eq 0 ]] && exit 0 || exit 1
