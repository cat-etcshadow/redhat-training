#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# A swap partition must be active
swapon --show --noheadings | grep -q 'partition' \
  || fail "No swap partition is active (swapon --show shows no partition swap)"

# Must be in /etc/fstab
grep -q 'swap' /etc/fstab || fail "No swap entry in /etc/fstab"

# fstab entry must use UUID
grep 'swap' /etc/fstab | grep -qiE 'UUID=|uuid=' \
  || fail "Swap entry in /etc/fstab does not use UUID"

[[ $errors -eq 0 ]] && exit 0 || exit 1
