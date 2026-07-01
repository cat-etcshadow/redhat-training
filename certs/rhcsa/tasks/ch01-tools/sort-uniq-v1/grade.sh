#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$LOG_FILE" ]]    || fail "$LOG_FILE does not exist"
[[ -f "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE does not exist"

actual=$(tr -d '[:space:]' < "$OUTPUT_FILE" 2>/dev/null || echo "")
[[ "$actual" == "$TOP_USER" ]] \
  || fail "$OUTPUT_FILE contains '$actual', expected '$TOP_USER'"

[[ $errors -eq 0 ]] && exit 0 || exit 1
