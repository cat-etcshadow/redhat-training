#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-enabled postfix &>/dev/null || fail "postfix is not enabled"
systemctl is-active  postfix &>/dev/null || fail "postfix is not running"

[[ $errors -eq 0 ]] && exit 0 || exit 1
