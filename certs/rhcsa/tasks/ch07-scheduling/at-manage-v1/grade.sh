#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

queue=$(atq 2>/dev/null)
count=$(echo "$queue" | grep -c . || true)
[[ "$count" -eq 2 ]] || fail "expected exactly 2 queued at jobs, found $count"

found_remove=0 found_keep1=0 found_keep2=0
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  job_id=$(awk '{print $1}' <<< "$line")
  body=$(at -c "$job_id" 2>/dev/null)
  echo "$body" | grep -q "$REMOVE_FILE" && found_remove=1
  echo "$body" | grep -q "$KEEP_FILE1"  && found_keep1=1
  echo "$body" | grep -q "$KEEP_FILE2"  && found_keep2=1
done <<< "$queue"

[[ "$found_remove" -eq 0 ]] \
  || fail "a queued job still references $REMOVE_FILE — it should have been removed with atrm"
[[ "$found_keep1" -eq 1 ]] \
  || fail "the job writing to $KEEP_FILE1 is missing — it should have stayed queued"
[[ "$found_keep2" -eq 1 ]] \
  || fail "the job writing to $KEEP_FILE2 is missing — it should have stayed queued"

[[ $errors -eq 0 ]] && exit 0 || exit 1
