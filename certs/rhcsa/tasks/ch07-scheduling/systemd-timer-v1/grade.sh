#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f /etc/systemd/system/cleanup.service ]] || fail "cleanup.service does not exist"
[[ -f /etc/systemd/system/cleanup.timer   ]] || fail "cleanup.timer does not exist"

# Service must run cleanup.sh
grep -q 'cleanup\.sh' /etc/systemd/system/cleanup.service \
  || fail "cleanup.service does not reference cleanup.sh"
grep -q 'Type=oneshot' /etc/systemd/system/cleanup.service \
  || fail "cleanup.service is not Type=oneshot"

# Timer must have 15-minute interval
grep -qiE 'OnCalendar=\*:0/15|OnUnitActiveSec=15min|OnActiveSec=15min' \
  /etc/systemd/system/cleanup.timer \
  || fail "cleanup.timer does not run every 15 minutes"

systemctl is-enabled cleanup.timer &>/dev/null || fail "cleanup.timer is not enabled"
systemctl is-active  cleanup.timer &>/dev/null || fail "cleanup.timer is not active"

[[ $errors -eq 0 ]] && exit 0 || exit 1
