#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE does not exist"
[[ -s "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE is empty"

grep -q "$ERR_MESSAGE" "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE is missing the error-priority message"

grep -q "$INFO_MESSAGE" "$OUTPUT_FILE" \
  && fail "$OUTPUT_FILE includes the info-priority message — should be filtered to err or higher"

[[ $errors -eq 0 ]] && exit 0 || exit 1
