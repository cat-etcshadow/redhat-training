#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

current=$(getsebool ftpd_anon_write 2>/dev/null | awk '{print $3}')
[[ "$current" == "on" ]] \
  || fail "ftpd_anon_write is $current, expected on"

persistent=$(semanage boolean -l 2>/dev/null \
  | awk '/ftpd_anon_write/{print $3}' | tr -d ',')
[[ "$persistent" == "on" ]] \
  || fail "ftpd_anon_write persistent value is $persistent — use setsebool -P"

[[ $errors -eq 0 ]] && exit 0 || exit 1
