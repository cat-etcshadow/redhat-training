#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

crontab=$(crontab -l -u "$CRON_USER" 2>/dev/null || echo "")
[[ -n "$crontab" ]] || fail "$CRON_USER has no crontab"

script_esc="${CRON_SCRIPT//./\\.}"
echo "$crontab" | grep -qE "^${CRON_MIN}[[:space:]]+${CRON_HOUR}[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*.*${script_esc}" \
  || fail "No cron entry '${CRON_MIN} ${CRON_HOUR} * * * ${CRON_SCRIPT}' found in ${CRON_USER}'s crontab"

[[ $errors -eq 0 ]] && exit 0 || exit 1
