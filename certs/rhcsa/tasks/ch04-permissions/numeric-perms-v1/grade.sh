#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

check() {
  local file="$1" expected="$2"
  local path="$APP_DIR/$file"
  [[ -f "$path" ]] || { fail "$path does not exist"; return; }
  local mode; mode=$(stat -c '%a' "$path")
  [[ "$mode" == "$expected" ]] \
    || fail "$path has mode $mode, expected $expected"
}

check "$FILE1" "$MODE1"
check "$FILE2" "$MODE2"
check "$FILE3" "$MODE3"
check "$FILE4" "$MODE4"

[[ $errors -eq 0 ]] && exit 0 || exit 1
