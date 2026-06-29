#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-active atd &>/dev/null || fail "atd is not running"
systemctl is-enabled atd &>/dev/null || fail "atd is not enabled"

queue=$(atq 2>/dev/null)
[[ -n "$queue" ]] || fail "No at jobs are queued (use 'at now + $AT_DELAY minutes')"

# Check queued job body contains the output file
found=0
while IFS= read -r line; do
  job_id=$(awk '{print $1}' <<< "$line")
  if at -c "$job_id" 2>/dev/null | grep -q "$AT_OUTFILE"; then
    found=1; break
  fi
done <<< "$queue"
[[ $found -eq 1 ]] || fail "Queued at job does not write to $AT_OUTFILE"

[[ $errors -eq 0 ]] && exit 0 || exit 1
