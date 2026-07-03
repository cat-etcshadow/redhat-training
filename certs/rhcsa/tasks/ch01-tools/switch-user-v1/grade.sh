#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

home="/home/$TARGET_USER"
file="$home/confirmed.txt"

if [[ ! -f "$file" ]]; then
  fail "$file does not exist"
else
  owner=$(stat -c '%U' "$file")
  [[ "$owner" == "$TARGET_USER" ]] \
    || fail "$file is not owned by $TARGET_USER (owned by $owner)"

  who_line=$(sed -n '1p' "$file")
  pwd_line=$(sed -n '2p' "$file")

  [[ "$who_line" == "$TARGET_USER" ]] \
    || fail "first line does not match whoami output for $TARGET_USER"
  [[ "$pwd_line" == "$home" ]] \
    || fail "second line ('$pwd_line') is not $home — a full login shell (su -) must be used"
fi

[[ $errors -eq 0 ]] && exit 0 || exit 1
