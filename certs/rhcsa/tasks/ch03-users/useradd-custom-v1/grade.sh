#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

entry=$(getent passwd "$SVC_USER") || fail "$SVC_USER does not exist"

svc_uid=$(echo "$entry" | cut -d: -f3)
[[ -n "$svc_uid" && "$svc_uid" -lt 1000 ]] \
  || fail "$SVC_USER has UID $svc_uid, expected a system UID below 1000"

home=$(echo "$entry" | cut -d: -f6)
[[ "$home" == "$SVC_HOME" ]] \
  || fail "$SVC_USER home field is '$home', expected '$SVC_HOME'"

shell=$(echo "$entry" | cut -d: -f7)
[[ "$shell" == "/sbin/nologin" || "$shell" == "/usr/sbin/nologin" ]] \
  || fail "$SVC_USER shell is '$shell', expected nologin"

comment=$(echo "$entry" | cut -d: -f5)
[[ "$comment" == "$SVC_COMMENT" ]] \
  || fail "$SVC_USER comment field is '$comment', expected '$SVC_COMMENT'"

[[ ! -d "$SVC_HOME" ]] \
  || fail "$SVC_HOME was created — useradd should have been run with -M"

[[ $errors -eq 0 ]] && exit 0 || exit 1
