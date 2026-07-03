#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

pgrep -f rhtr_cpu_hog &>/dev/null || fail "rhtr_cpu_hog process is no longer running"

[[ -s "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE is missing or empty"

grep -qi "load average" "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE does not look like top output (missing the load average header)"

grep -q "rhtr_cpu_hog" "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE does not contain an entry for rhtr_cpu_hog"

[[ $errors -eq 0 ]] && exit 0 || exit 1
