#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

entry=$(awk -v mp="$MOUNT_POINT" '$2==mp' /etc/fstab)
[[ -n "$entry" ]] || fail "no /etc/fstab entry for $MOUNT_POINT"

opts=$(echo "$entry" | awk '{print $4}')
echo ",${opts}," | grep -q ",noauto," || fail "fstab entry for $MOUNT_POINT is missing 'noauto'"
echo ",${opts}," | grep -q ",user,"   || fail "fstab entry for $MOUNT_POINT is missing 'user'"

mountpoint -q "$MOUNT_POINT" && umount "$MOUNT_POINT" 2>/dev/null

su - "$TEST_USER" -c "mount $MOUNT_POINT" &>/dev/null \
  || fail "$TEST_USER could not mount $MOUNT_POINT without root privileges"

mountpoint -q "$MOUNT_POINT" \
  || fail "$MOUNT_POINT was not actually mounted after $TEST_USER ran mount"

su - "$TEST_USER" -c "umount $MOUNT_POINT" &>/dev/null \
  || fail "$TEST_USER could not unmount $MOUNT_POINT without root privileges"

[[ $errors -eq 0 ]] && exit 0 || exit 1
