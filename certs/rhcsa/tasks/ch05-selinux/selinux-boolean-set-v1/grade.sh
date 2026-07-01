#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

current=$(getsebool "$BOOL_NAME" 2>/dev/null | awk '{print $3}')
[[ "$current" == "on" ]] || fail "$BOOL_NAME is $current, expected on"

persistent=$(semanage boolean -l 2>/dev/null | grep -w "$BOOL_NAME" | grep -oE '\((on|off)' | head -1 | tr -d '(')
[[ "$persistent" == "on" ]] \
  || fail "$BOOL_NAME is not set persistently — use setsebool -P"

[[ $errors -eq 0 ]] && exit 0 || exit 1
