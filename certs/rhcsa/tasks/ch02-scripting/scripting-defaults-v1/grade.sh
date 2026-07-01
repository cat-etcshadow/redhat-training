#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

grep -qE '\$\{[A-Za-z_]+:-[^}]*\}' "$SCRIPT_PATH" \
  || fail "script does not use parameter-expansion defaults (\${VAR:-default})"

# no env, no arg → both defaults apply
out=$(env -u APP_ENV "$SCRIPT_PATH") && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "default invocation exited $rc, expected 0"
echo "$out" | grep -q "Deploying to localhost in development mode" \
  || fail "default output wrong: $out"

# explicit env + arg
out=$(APP_ENV=production "$SCRIPT_PATH" webserver) && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "production invocation exited $rc"
echo "$out" | grep -q "Deploying to webserver in production mode" \
  || fail "production output wrong: $out"

# invalid env → error
out=$(APP_ENV=bogus "$SCRIPT_PATH" 2>&1) && fail "invalid env should exit non-zero" || rc=$?
[[ $rc -ne 0 ]] || fail "invalid env exit code is 0, expected non-zero"
echo "$out" | grep -qi "error" || fail "invalid env case doesn't print an error: $out"

[[ $errors -eq 0 ]] && exit 0 || exit 1
