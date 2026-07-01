#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

vgs "$VG_NAME" &>/dev/null || fail "volume group $VG_NAME does not exist"

pv_count=$(vgs --noheadings -o pv_count "$VG_NAME" 2>/dev/null | tr -d ' ')
[[ "$pv_count" -ge 2 ]] \
  || fail "$VG_NAME has $pv_count physical volume(s), expected at least 2"

vg_size=$(vgs --noheadings -o vg_size --units m "$VG_NAME" 2>/dev/null | tr -d ' m')
python3 -c "exit(0 if float('${vg_size}') >= 3000 else 1)" \
  || fail "$VG_NAME total size is ${vg_size}m — does not reflect the new PV being added"

[[ $errors -eq 0 ]] && exit 0 || exit 1
