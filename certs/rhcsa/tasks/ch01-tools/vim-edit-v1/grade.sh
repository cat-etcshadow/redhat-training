#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$CONF_FILE" ]] || fail "$CONF_FILE does not exist"

grep -qx "HOSTNAME=${NEW_HOSTNAME}" "$CONF_FILE" \
  || fail "HOSTNAME is not set to '${NEW_HOSTNAME}' in $CONF_FILE"

grep -qx "LISTEN_PORT=${LISTEN_PORT}" "$CONF_FILE" \
  || fail "LISTEN_PORT is not set to '${LISTEN_PORT}' in $CONF_FILE"

grep -qx "TIMEOUT=${TIMEOUT_VAL}" "$CONF_FILE" \
  || fail "TIMEOUT is not set to '${TIMEOUT_VAL}' in $CONF_FILE"

grep -qx "DEBUG=false" "$CONF_FILE" \
  || fail "DEBUG is not set to 'false' in $CONF_FILE"

[[ $errors -eq 0 ]] && exit 0 || exit 1
