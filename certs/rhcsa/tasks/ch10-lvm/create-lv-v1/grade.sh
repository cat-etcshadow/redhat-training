#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

vgs "$VG_NAME" &>/dev/null || fail "Volume group $VG_NAME does not exist"
lvs "$VG_NAME/$LV_NAME" &>/dev/null || fail "Logical volume $LV_NAME does not exist in $VG_NAME"

lv_size=$(lvs --noheadings -o lv_size --units m "$VG_NAME/$LV_NAME" 2>/dev/null | tr -d ' m')
lo=$(( LV_SIZE_MB * 9 / 10 ))
hi=$(( LV_SIZE_MB * 12 / 10 ))
python3 -c "exit(0 if ${lo} <= float('${lv_size}') <= ${hi} else 1)" \
  || fail "$LV_NAME size is ${lv_size}m, expected ~${LV_SIZE_MB}m"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"
fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "xfs" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected xfs"

uuid=$(findmnt -n -o UUID "$MOUNT_POINT")
grep -q "$uuid" /etc/fstab || fail "$MOUNT_POINT not in /etc/fstab by UUID"

[[ $errors -eq 0 ]] && exit 0 || exit 1
