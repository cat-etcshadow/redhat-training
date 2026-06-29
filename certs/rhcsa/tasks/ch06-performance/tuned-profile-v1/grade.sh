#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-enabled tuned &>/dev/null || fail "tuned service is not enabled"
systemctl is-active  tuned &>/dev/null || fail "tuned service is not running"

profile=$(tuned-adm active 2>/dev/null | awk -F': ' '{print $2}')
[[ "$profile" == "$TUNED_PROFILE" ]] \
  || fail "active tuned profile is '$profile', expected $TUNED_PROFILE"

[[ $errors -eq 0 ]] && exit 0 || exit 1
