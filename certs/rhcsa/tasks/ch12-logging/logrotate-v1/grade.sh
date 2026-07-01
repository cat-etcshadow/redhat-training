#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

config="/etc/logrotate.d/${APP_NAME}"
[[ -f "$config" ]] || fail "$config does not exist"

grep -qF "$LOG_FILE" "$config"                    || fail "$config does not reference $LOG_FILE"
grep -qE "size[[:space:]]+${MAX_SIZE}"      "$config" || fail "$config missing 'size ${MAX_SIZE}'"
grep -qE "rotate[[:space:]]+${ROTATE_COUNT}" "$config" || fail "$config missing 'rotate ${ROTATE_COUNT}'"
grep -qw "compress"     "$config" || fail "$config is missing 'compress'"
grep -qw "copytruncate" "$config" || fail "$config is missing 'copytruncate'"

logrotate -f "$config" &>/tmp/rhtr-logrotate-out.txt || true
rotated=$(ls "${LOG_FILE}".1* 2>/dev/null | head -1)
[[ -n "$rotated" ]] \
  || fail "logrotate -f produced no rotated file for $LOG_FILE — check the config is valid"

[[ $errors -eq 0 ]] && exit 0 || exit 1
