#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

grep -q 'dead-beef-0000-0000-bad-fstab' /etc/fstab \
  && fail "Broken fstab entry (UUID=dead-beef-...) is still present"

mount_output=$(mount -a 2>&1 || true)
[[ -z "$mount_output" ]] || fail "mount -a produced errors: $mount_output"

[[ $errors -eq 0 ]] && exit 0 || exit 1
