#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$REPORT_FILE" ]] || fail "$REPORT_FILE does not exist"

grep -qF "$APP_DIR/$GOOD_BINARY" "$REPORT_FILE" \
  || fail "$REPORT_FILE does not list $APP_DIR/$GOOD_BINARY"
grep -qF "$APP_DIR/$BAD_BINARY" "$REPORT_FILE" \
  || fail "$REPORT_FILE does not list $APP_DIR/$BAD_BINARY"
grep -qF "$APP_DIR/readme.txt" "$REPORT_FILE" \
  && fail "$REPORT_FILE lists readme.txt — it never had the SUID bit set"

good_mode=$(stat -c '%a' "$APP_DIR/$GOOD_BINARY")
[[ "$good_mode" == "4755" ]] \
  || fail "$GOOD_BINARY lost its SUID bit (mode $good_mode) — it should remain set"

bad_mode=$(stat -c '%a' "$APP_DIR/$BAD_BINARY")
[[ "$bad_mode" == "755" ]] \
  || fail "$BAD_BINARY still has the SUID bit set (mode $bad_mode)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
