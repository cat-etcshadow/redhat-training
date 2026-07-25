#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

id "$CONTRACT_USER" &>/dev/null || fail "$CONTRACT_USER does not exist"

expected_days=$(( $(date -d "$EXPIRE_DATE 12:00:00" +%s) / 86400 ))
actual_days=$(getent shadow "$CONTRACT_USER" | cut -d: -f8)

[[ -n "$actual_days" ]] || fail "$CONTRACT_USER has no account expiration date set"
[[ "$actual_days" == "$expected_days" ]] \
  || fail "$CONTRACT_USER expiration is day $actual_days, expected $expected_days ($EXPIRE_DATE)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
