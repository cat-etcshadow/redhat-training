#!/usr/bin/env bash
set -euo pipefail
errors=0

fail() { echo "FAIL: $*"; (( errors++ )); }

# SELinux must still be enforcing
mode=$(getenforce)
[[ "$mode" == "Enforcing" ]] \
  || fail "SELinux is $mode — must remain Enforcing"

# All files and the directory must have httpd_sys_content_t
while IFS= read -r path; do
  ctx=$(ls -Z "$path" 2>/dev/null | awk '{print $1}')
  echo "$ctx" | grep -q 'httpd_sys_content_t' \
    || fail "$path has wrong context: $ctx (expected httpd_sys_content_t)"
done < <(find "/var/www/html/$WEBDIR" -maxdepth 2)

semanage fcontext -l 2>/dev/null \
  | grep -q "/var/www/html/${WEBDIR}.*httpd_sys_content_t\|/var/www/html(/.*)?.*httpd_sys_content_t" \
  || fail "No persistent semanage fcontext entry covers /var/www/html/$WEBDIR"

[[ $errors -eq 0 ]] && exit 0 || exit 1
