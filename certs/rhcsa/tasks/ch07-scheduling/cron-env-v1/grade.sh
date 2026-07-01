#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

crontab_content=$(crontab -l -u "$CRON_USER" 2>/dev/null || echo "")
[[ -n "$crontab_content" ]] || fail "$CRON_USER has no crontab"

tool_dir_esc="${TOOL_DIR//\//\\/}"
echo "$crontab_content" | grep -qE "^PATH=.*${tool_dir_esc}" \
  || fail "crontab for $CRON_USER does not set PATH to include $TOOL_DIR"

script_esc="${SCRIPT_PATH//./\\.}"
echo "$crontab_content" | grep -qE "\*/5[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*.*${script_esc}" \
  || fail "crontab for $CRON_USER does not run $SCRIPT_PATH every 5 minutes"

[[ $errors -eq 0 ]] && exit 0 || exit 1
