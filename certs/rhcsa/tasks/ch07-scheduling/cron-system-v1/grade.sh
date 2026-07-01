#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$CRON_FILE" ]] || fail "$CRON_FILE does not exist"

script_esc="${SCRIPT_PATH//./\\.}"
grep -qE "^\*/${INTERVAL_MIN}[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+${CRON_USER}[[:space:]]+${script_esc}" \
  "$CRON_FILE" \
  || fail "$CRON_FILE does not contain a valid system crontab entry (*/${INTERVAL_MIN} * * * * ${CRON_USER} ${SCRIPT_PATH})"

[[ $errors -eq 0 ]] && exit 0 || exit 1
