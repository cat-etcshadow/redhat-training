#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f /etc/tmpfiles.d/myapp.conf ]] || fail "/etc/tmpfiles.d/myapp.conf does not exist"

conf=$(cat /etc/tmpfiles.d/myapp.conf)
echo "$conf" | grep -q '/run/myapp' || fail "/run/myapp not configured in myapp.conf"
echo "$conf" | grep '/run/myapp' | grep -q '0750' \
  || fail "permissions 0750 not set for /run/myapp in myapp.conf"

[[ -d /run/myapp ]] || fail "/run/myapp directory does not exist (run systemd-tmpfiles --create?)"
owner=$(stat -c '%U' /run/myapp)
group=$(stat -c '%G' /run/myapp)
[[ "$owner" == "myapp" ]] || fail "/run/myapp owner is $owner, expected myapp"
[[ "$group" == "myapp" ]] || fail "/run/myapp group is $group, expected myapp"
mode=$(stat -c '%a' /run/myapp)
[[ "$mode" == "750"  ]] || fail "/run/myapp mode is $mode, expected 750"

[[ $errors -eq 0 ]] && exit 0 || exit 1
