#!/usr/bin/env bash
set -euo pipefail
errors=0

fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

while IFS= read -r path; do
  ctx=$(ls -Zd "$path" 2>/dev/null | awk '{print $1}')
  echo "$ctx" | grep -q 'public_content_t' \
    || fail "$path has wrong context: $ctx (expected public_content_t)"
done < <(find /srv/ftp/pub -maxdepth 2)

semanage fcontext -l 2>/dev/null \
  | grep '/srv/ftp/pub' \
  | grep -q 'public_content_t' \
  || fail "No persistent semanage fcontext entry for /srv/ftp/pub with public_content_t"

[[ $errors -eq 0 ]] && exit 0 || exit 1
