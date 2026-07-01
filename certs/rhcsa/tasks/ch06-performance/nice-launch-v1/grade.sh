#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

mapfile -t pids < <(pgrep -u "$TARGET_USER" -f rhtr-user-job)
[[ ${#pids[@]} -ge 2 ]] \
  || fail "expected at least 2 rhtr-user-job processes for $TARGET_USER, found ${#pids[@]}"

for pid in "${pids[@]}"; do
  n=$(ps -o nice= -p "$pid" 2>/dev/null | tr -d ' ')
  [[ "$n" == "$NICE_VAL" ]] \
    || fail "process $pid (user $TARGET_USER) has nice value '$n', expected $NICE_VAL"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
