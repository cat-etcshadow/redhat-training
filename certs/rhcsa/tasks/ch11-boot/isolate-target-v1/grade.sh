#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl list-units --type=target --state=active --no-legend 2>/dev/null \
  | grep -q "multi-user.target" \
  || fail "multi-user.target is not the active runtime target"

systemctl is-active sshd &>/dev/null \
  || fail "sshd is not active — the system may not have fully returned to multi-user.target"

original=$(cat /root/.rhtr-original-default-target 2>/dev/null || echo "")
current=$(systemctl get-default)
[[ -n "$original" && "$current" == "$original" ]] \
  || fail "persistent default target changed (was '$original', now '$current') — only the runtime target should change"

journalctl -q -b 0 2>/dev/null | grep -qi "rescue.target" \
  || fail "no evidence the system was isolated into rescue.target"

[[ $errors -eq 0 ]] && exit 0 || exit 1
