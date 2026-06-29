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
ENV="${CONFIG_DIR}/app.env"

[[ -f "$CONF" ]] || fail "app.conf not generated at $CONF"
[[ -f "$ENV"  ]] || fail "app.env not generated at $ENV"

# app.conf: variable substitution must have occurred
grep -q "user = ${APP_USER}" "$CONF" \
  || fail "app.conf missing 'user = $APP_USER'"
grep -q "port = ${APP_PORT}" "$CONF" \
  || fail "app.conf missing 'port = $APP_PORT'"
grep -q "${APP_USER}" "$CONF" \
  || fail "app.conf missing pid_file with $APP_USER"

# app.env: must contain LITERAL \$APP_USER (no expansion)
grep -qF 'APP_USER=$APP_USER' "$ENV" \
  || fail "app.env: APP_USER line should be literal '\$APP_USER' (no substitution)"
grep -qF 'APP_PORT=$APP_PORT' "$ENV" \
  || fail "app.env: APP_PORT line should be literal '\$APP_PORT' (no substitution)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
