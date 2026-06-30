#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$OUTPUT_FILE" ]] \
  || fail "$OUTPUT_FILE does not exist — run: journalctl -t $SYSLOG_ID --no-pager > $OUTPUT_FILE"

[[ -s "$OUTPUT_FILE" ]] \
  || fail "$OUTPUT_FILE is empty"

grep -q "$SYSLOG_ID" "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE does not contain entries for identifier '$SYSLOG_ID'"

grep -q "$LOG_MESSAGE" "$OUTPUT_FILE" \
  || fail "Expected log message not found in $OUTPUT_FILE — did you filter by the right identifier?"

[[ -f "$BOOT_LOG_FILE" ]] \
  || fail "$BOOT_LOG_FILE does not exist — run: journalctl -b --no-pager > $BOOT_LOG_FILE"

[[ -s "$BOOT_LOG_FILE" ]] \
  || fail "$BOOT_LOG_FILE is empty — check: journalctl -b --no-pager"

[[ $errors -eq 0 ]] && exit 0 || exit 1
