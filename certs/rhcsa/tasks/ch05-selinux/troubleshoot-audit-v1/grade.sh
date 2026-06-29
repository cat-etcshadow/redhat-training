#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

current=$(getsebool httpd_enable_cgi 2>/dev/null | awk '{print $3}')
[[ "$current" == "on" ]] || fail "httpd_enable_cgi is $current, expected on"

persistent=$(semanage boolean -l 2>/dev/null | awk '/httpd_enable_cgi/{print $3}' | tr -d ',')
[[ "$persistent" == "on" ]] || fail "httpd_enable_cgi is not persistent (use setsebool -P)"

systemctl is-active httpd &>/dev/null || fail "httpd is not running"

[[ $errors -eq 0 ]] && exit 0 || exit 1
