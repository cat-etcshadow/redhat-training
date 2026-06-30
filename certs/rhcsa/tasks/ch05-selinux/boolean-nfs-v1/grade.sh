#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

current=$(getsebool use_nfs_home_dirs 2>/dev/null | awk '{print $3}')
[[ "$current" == "on" ]] || fail "use_nfs_home_dirs is $current, expected on"

persistent=$(semanage boolean -l 2>/dev/null | awk '/use_nfs_home_dirs/{print $4}' | tr -d '),')
[[ "$persistent" == "on" ]] || fail "use_nfs_home_dirs is not set persistently (use setsebool -P)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
