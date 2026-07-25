#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -e /run/systemd/shutdown/scheduled ]] \
  && fail "a shutdown/reboot is still pending — it must be cancelled"

journalctl -q -b 0 2>/dev/null | grep -qiE "shutdown scheduled for|reboot scheduled for" \
  || fail "no evidence a reboot was scheduled with shutdown this boot"

journalctl -q -b 0 2>/dev/null | grep -qiE "shutdown cancel|reboot cancel" \
  || fail "no evidence the scheduled shutdown was cancelled with 'shutdown -c'"

[[ $errors -eq 0 ]] && exit 0 || exit 1
