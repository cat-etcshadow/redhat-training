#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1}' | sed -n '2p')
[[ -n "$DISK" ]] || fail "no extra disk found"

# must have GPT partition table
pttype=$(blkid -o value -s PTTYPE "$DISK" 2>/dev/null || parted "$DISK" print 2>/dev/null | awk '/Partition Table/{print $3}')
echo "$pttype" | grep -qi 'gpt' \
  || fail "disk $DISK does not have a GPT partition table (found: $pttype)"

mountpoint -q "$MOUNT_POINT" || fail "$MOUNT_POINT is not mounted"

fstype=$(findmnt -n -o FSTYPE "$MOUNT_POINT")
[[ "$fstype" == "xfs" ]] || fail "$MOUNT_POINT filesystem is $fstype, expected xfs"

uuid=$(findmnt -n -o UUID "$MOUNT_POINT")
grep -q "$uuid" /etc/fstab \
  || fail "$MOUNT_POINT not in /etc/fstab by UUID (found UUID=$uuid)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
