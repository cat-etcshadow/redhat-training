#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl list-units --type=target --state=active --no-legend 2>/dev/null \
  | grep -q "multi-user.target" \
  || fail "multi-user.target is not the active runtime target"

systemctl is-active sshd &>/dev/null \
  || fail "sshd is not active — the system may not have fully returned to multi-user.target"

# Deliberately does NOT require the persistent default to equal a snapshot
# taken before the exam started — this session's other selected tasks (e.g.
# ch11-boot/boot-target-v1) are free to change the persistent default for
# their own, unrelated reasons. The actual skill this task tests is "isolate
# is a runtime-only switch, unlike set-default" — checked by confirming the
# persistent default was never left pointing at rescue.target itself.
current=$(systemctl get-default)
[[ "$current" != "rescue.target" ]] \
  || fail "persistent default target is rescue.target — use 'systemctl isolate', not 'systemctl set-default', for a temporary switch"

journalctl -q -b 0 2>/dev/null | grep -qi "rescue.target" \
  || fail "no evidence the system was isolated into rescue.target"

[[ $errors -eq 0 ]] && exit 0 || exit 1
