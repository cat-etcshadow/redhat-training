#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -f "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE does not exist"
[[ -s "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE is empty"

grep -q "$KEEP_MESSAGE" "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE is missing the message logged at/after $SINCE_TS"

grep -q "$DECOY_MESSAGE" "$OUTPUT_FILE" \
  && fail "$OUTPUT_FILE includes a message logged before $SINCE_TS — should have been filtered out"

[[ $errors -eq 0 ]] && exit 0 || exit 1
