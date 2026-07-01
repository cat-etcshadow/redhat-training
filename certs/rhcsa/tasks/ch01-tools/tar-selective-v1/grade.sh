#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$ARCHIVE" ]] || fail "$ARCHIVE is missing — do not delete the source archive"

extracted="$EXTRACT_DIR/$TARGET_FILE"
[[ -f "$extracted" ]] || fail "$extracted does not exist"

[[ -f "$EXTRACT_DIR/logs/app.log" ]] \
  && fail "logs/app.log was extracted — only $TARGET_FILE should have been extracted"
[[ -f "$EXTRACT_DIR/src/main.py" ]] \
  && fail "src/main.py was extracted — only $TARGET_FILE should have been extracted"

[[ $errors -eq 0 ]] && exit 0 || exit 1
