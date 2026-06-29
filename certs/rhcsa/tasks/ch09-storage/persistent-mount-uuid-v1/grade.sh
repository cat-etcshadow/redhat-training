#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mountpoint -q /mnt/fixme || fail "/mnt/fixme is not mounted"
grep '/mnt/fixme' /etc/fstab | grep -qE '^/dev/' \
  && fail "/etc/fstab still uses a /dev/ path for /mnt/fixme — must use UUID"
grep '/mnt/fixme' /etc/fstab | grep -qiE 'UUID=' \
  || fail "/etc/fstab entry for /mnt/fixme does not use UUID"

[[ $errors -eq 0 ]] && exit 0 || exit 1
