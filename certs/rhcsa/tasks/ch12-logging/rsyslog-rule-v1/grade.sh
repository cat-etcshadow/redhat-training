#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

conf_base=$(basename "$CONF_FILE")
[[ -f "$CONF_FILE" ]] || fail "$CONF_FILE does not exist"

grep -qiE "${FACILITY}\.${SEVERITY}|${FACILITY}\.\*" "$CONF_FILE" \
  || fail "$conf_base does not filter ${FACILITY}.${SEVERITY} messages"

log_esc="${LOG_FILE//\//\\/}"
grep -qE "$log_esc|$(basename "$LOG_FILE")" "$CONF_FILE" \
  || fail "$conf_base does not write to $LOG_FILE"

systemctl is-active rsyslog &>/dev/null || fail "rsyslog is not running"

logger -p "${FACILITY}.${SEVERITY}" "RHTR grader test message"
sleep 1
[[ -f "$LOG_FILE" ]] \
  || fail "$LOG_FILE was not created after test message"
grep -q 'RHTR grader test message' "$LOG_FILE" \
  || fail "test ${FACILITY}.${SEVERITY} message not found in $LOG_FILE"

[[ $errors -eq 0 ]] && exit 0 || exit 1
