#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

systemctl is-active atd &>/dev/null || fail "atd is not running"
systemctl is-enabled atd &>/dev/null || fail "atd is not enabled"

# batch jobs run as soon as load permits, which on an idle grading VM can be
# almost immediate — poll instead of assuming the job is still queued.
for _ in $(seq 1 18); do
  [[ -f "$BATCH_OUTFILE" ]] && break
  sleep 5
done

[[ -f "$BATCH_OUTFILE" ]] || fail "$BATCH_OUTFILE was never created — no batch job appears to have run"
grep -qF "$BATCH_MESSAGE" "$BATCH_OUTFILE" \
  || fail "$BATCH_OUTFILE does not contain the expected message"

[[ $errors -eq 0 ]] && exit 0 || exit 1
