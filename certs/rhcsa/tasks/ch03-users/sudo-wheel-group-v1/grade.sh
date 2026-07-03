#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

id "$WHEEL_USER" &>/dev/null || fail "$WHEEL_USER does not exist"

id "$WHEEL_USER" | grep -q '(wheel)' \
  || fail "$WHEEL_USER is not a member of the wheel group"

grep -qE '^\s*%wheel\s+ALL=\(ALL\)\s+ALL' /etc/sudoers \
  || fail "the %wheel rule in /etc/sudoers is not active"

visudo -c &>/dev/null || fail "/etc/sudoers is not syntactically valid"

sudo -l -U "$WHEEL_USER" 2>/dev/null | grep -q '(ALL)\s*ALL' \
  || fail "$WHEEL_USER does not show full sudo access via sudo -l"

[[ $errors -eq 0 ]] && exit 0 || exit 1
