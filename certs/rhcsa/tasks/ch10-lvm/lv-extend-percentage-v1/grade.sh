#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

lvs "$VG_NAME/$LV_NAME" &>/dev/null || fail "$LV_NAME does not exist in $VG_NAME"

vg_free=$(vgs --noheadings -o vg_free --units m "$VG_NAME" 2>/dev/null | tr -d ' m')
python3 -c "exit(0 if float('${vg_free}') < 20 else 1)" \
  || fail "$VG_NAME still has ${vg_free}M free — $LV_NAME was not extended to use all remaining space"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fs_size=$(df --block-size=M "$MOUNT_POINT" | awk 'NR==2{gsub(/M/,"",$2); print $2}')
python3 -c "exit(0 if float('${fs_size}') >= 1000 else 1)" \
  || fail "$MOUNT_POINT filesystem shows only ${fs_size}M — filesystem not grown after lvextend"

[[ $errors -eq 0 ]] && exit 0 || exit 1
