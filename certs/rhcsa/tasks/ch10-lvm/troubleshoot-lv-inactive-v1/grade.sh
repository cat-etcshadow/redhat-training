#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

vgs rhtr_dbvg &>/dev/null || fail "volume group rhtr_dbvg is missing"
lvs rhtr_dbvg/dbdata &>/dev/null || fail "logical volume dbdata is missing"

lv_attr=$(lvs --noheadings -o lv_attr rhtr_dbvg/dbdata 2>/dev/null | tr -d ' ')
[[ "${lv_attr:4:1}" == "a" ]] || fail "logical volume dbdata is not active"

mountpoint -q /mnt/dbdata || fail "/mnt/dbdata is not mounted"

uuid=$(findmnt -n -o UUID /mnt/dbdata)
grep -q "$uuid" /etc/fstab || fail "/mnt/dbdata is not in /etc/fstab by UUID"

[[ $errors -eq 0 ]] && exit 0 || exit 1
