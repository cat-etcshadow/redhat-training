#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

grep -q "$MOUNT_POINT" /etc/fstab \
  || fail "$MOUNT_POINT has no /etc/fstab entry — not persistent"

opts=$(findmnt -no OPTIONS "$MOUNT_POINT")
IFS=',' read -ra required <<< "$REQUIRED_OPTS"
for o in "${required[@]}"; do
  echo ",${opts}," | grep -q ",${o}," \
    || fail "$MOUNT_POINT is missing mount option '$o' (current: $opts)"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
