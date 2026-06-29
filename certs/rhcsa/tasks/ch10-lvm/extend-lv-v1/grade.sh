#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

lvs "$VG_NAME/$LV_NAME" &>/dev/null || fail "$LV_NAME does not exist in $VG_NAME"

lv_size=$(lvs --noheadings -o lv_size --units m "$VG_NAME/$LV_NAME" 2>/dev/null | tr -d ' m')
python3 -c "exit(0 if float('${lv_size}') >= ${EXTEND_MIN} else 1)" \
  || fail "$LV_NAME size is ${lv_size}m, expected >= ${EXTEND_MIN}m (400 + ${EXTEND_MB})"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fs_size=$(df --block-size=M "$MOUNT_POINT" | awk 'NR==2{gsub(/M/,"",$2); print $2}')
fs_min=$(( EXTEND_MIN - 100 ))
python3 -c "exit(0 if float('${fs_size}') >= ${fs_min} else 1)" \
  || fail "$MOUNT_POINT filesystem shows ${fs_size}M — filesystem not grown after lvextend?"

[[ $errors -eq 0 ]] && exit 0 || exit 1
