#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$OUT_FILE" ]] || fail "$OUT_FILE does not exist"

grep -qx 'REMOTE-OK' "$OUT_FILE" \
  || fail "$OUT_FILE does not contain the output of $REMOTE_SCRIPT"

year=$(date +%Y)
grep -qx "$year" "$OUT_FILE" \
  || fail "$OUT_FILE does not contain the current year ($year) from the remote date command"

[[ $errors -eq 0 ]] && exit 0 || exit 1
