#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

lvs "$VG_NAME/$SNAP_NAME" &>/dev/null || fail "$SNAP_NAME does not exist in $VG_NAME"

origin=$(lvs --noheadings -o origin "$VG_NAME/$SNAP_NAME" 2>/dev/null | tr -d ' ')
[[ "$origin" == "$LV_NAME" ]] \
  || fail "$SNAP_NAME's origin is '$origin', expected '$LV_NAME'"

attr=$(lvs --noheadings -o lv_attr "$VG_NAME/$SNAP_NAME" 2>/dev/null | tr -d ' ')
[[ "${attr:0:1}" == "s" ]] \
  || fail "$SNAP_NAME does not have snapshot attributes (lv_attr: $attr)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
