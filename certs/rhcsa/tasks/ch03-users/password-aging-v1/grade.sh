#!/usr/bin/env bash
set -euo pipefail
errors=0

fail() { echo "FAIL: $*"; (( errors++ )); }

s1=$(getent shadow "$USER1")
u1_min=$(echo "$s1"  | cut -d: -f4)
u1_max=$(echo "$s1"  | cut -d: -f5)
u1_warn=$(echo "$s1" | cut -d: -f6)
u1_inac=$(echo "$s1" | cut -d: -f7)

[[ "$u1_min"  == "$MIN_AGE"   ]] || fail "$USER1 min age is $u1_min, expected $MIN_AGE"
[[ "$u1_max"  == "$MAX_AGE1"  ]] || fail "$USER1 max age is $u1_max, expected $MAX_AGE1"
[[ "$u1_warn" == "$WARN_DAYS" ]] || fail "$USER1 warning days is $u1_warn, expected $WARN_DAYS"
[[ "$u1_inac" == "$INACTIVE"  ]] || fail "$USER1 inactive days is $u1_inac, expected $INACTIVE"

s2=$(getent shadow "$USER2")
u2_lastchg=$(echo "$s2" | cut -d: -f3)
u2_max=$(echo "$s2"     | cut -d: -f5)

[[ "$u2_lastchg" == "0" ]]   || fail "$USER2 password is not expired (lastchg=$u2_lastchg, expected 0)"
[[ "$u2_max" == "$MAX_AGE2" ]] || fail "$USER2 max age is $u2_max, expected $MAX_AGE2"

[[ $errors -eq 0 ]] && exit 0 || exit 1
