#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

path="/var/www/html/${WEBDIR}/page.html"
[[ -f "$path" ]] || fail "$path does not exist"

ctx=$(ls -Z "$path" 2>/dev/null | awk '{print $1}')
echo "$ctx" | grep -q 'httpd_sys_content_t' \
  || fail "$path has context $ctx, expected httpd_sys_content_t"

[[ $errors -eq 0 ]] && exit 0 || exit 1
