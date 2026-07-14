#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no-arg → exit 1
"$SCRIPT_PATH" &>/dev/null && fail "no-arg should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "no-arg exit code is $rc, expected 1"

# run with args
"$SCRIPT_PATH" "$APP_USER" "$APP_PORT" "$CONFIG_DIR" || fail "script failed with valid args"

CONF="${CONFIG_DIR}/app.conf"
[[ -f "$CONF" ]] || fail "app.conf not generated at $CONF"

# variable substitution must have occurred
grep -q "user = ${APP_USER}" "$CONF" \
  || fail "app.conf missing 'user = $APP_USER'"
grep -q "port = ${APP_PORT}" "$CONF" \
  || fail "app.conf missing 'port = $APP_PORT'"

[[ $errors -eq 0 ]] && exit 0 || exit 1
