#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no-arg should exit 1
"$SCRIPT_PATH" &>/dev/null && fail "exit code with no args should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "exit code with no args is $rc, expected 1"

# run with base dir
"$SCRIPT_PATH" "$BASE_DIR" || fail "script exited non-zero when run with $BASE_DIR"

for subdir in logs data config backups tmp; do
  full="${BASE_DIR}/${subdir}"
  [[ -d "$full" ]] || fail "directory $full was not created"
  [[ -f "${full}/README" ]] || fail "README missing in $full"
  grep -qi "$subdir" "${full}/README" \
    || fail "README in $full doesn't mention '$subdir'"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
