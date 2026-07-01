#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

ntp=$(timedatectl show -p NTP --value 2>/dev/null)

if [[ "$ACTION" == "disable" ]]; then
  [[ "$ntp" == "no" ]] || fail "NTP is '$ntp', expected disabled (no)"
else
  [[ "$ntp" == "yes" ]] || fail "NTP is '$ntp', expected enabled (yes)"
  systemctl is-active chronyd &>/dev/null \
    || fail "chronyd is not active even though NTP synchronization is enabled"
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
