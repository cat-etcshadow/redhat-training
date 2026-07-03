#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-active systemd-journald &>/dev/null || fail "systemd-journald is not running"
[[ -d /var/log/journal ]] || fail "/var/log/journal does not exist"

cap_num=${VACUUM_CAP%M}
cap_bytes=$(( cap_num * 1024 * 1024 ))
margin_bytes=$(( cap_bytes + 2*1024*1024 ))

actual_bytes=$(du -sb /var/log/journal 2>/dev/null | awk '{print $1}')
[[ -n "$actual_bytes" ]] || fail "could not measure the size of /var/log/journal"

(( actual_bytes <= margin_bytes )) \
  || fail "/var/log/journal is using $actual_bytes bytes, expected roughly <= $VACUUM_CAP"

[[ $errors -eq 0 ]] && exit 0 || exit 1
