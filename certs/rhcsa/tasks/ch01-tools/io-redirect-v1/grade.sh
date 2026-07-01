#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$OUT_FILE" ]] || fail "$OUT_FILE does not exist"
[[ -f "$ERR_FILE" ]] || fail "$ERR_FILE does not exist"

grep -q "PREVIOUS_RUN_MARKER" "$OUT_FILE" 2>/dev/null \
  || fail "$OUT_FILE lost its previous content — stdout must be appended, not overwritten"
grep -q "OK: operation completed" "$OUT_FILE" 2>/dev/null \
  || fail "$OUT_FILE missing the script's stdout content"
grep -q "ERROR: something went wrong" "$ERR_FILE" 2>/dev/null \
  || fail "$ERR_FILE missing the script's stderr content"

grep -q "ERROR: something went wrong" "$OUT_FILE" 2>/dev/null \
  && fail "$OUT_FILE contains stderr output — streams were not separated"
grep -q "OK: operation completed" "$ERR_FILE" 2>/dev/null \
  && fail "$ERR_FILE contains stdout output — streams were not separated"

[[ $errors -eq 0 ]] && exit 0 || exit 1
