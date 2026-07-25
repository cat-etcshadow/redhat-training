#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

podman exec rhtr-execlogs cat "/tmp/${MARKER_FILE}" 2>/dev/null | grep -q "hello from exec" \
  || fail "/tmp/${MARKER_FILE} inside rhtr-execlogs does not contain the expected content"

[[ -f "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE does not exist"
grep -q "container started" "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE does not contain the container's log output"

[[ $errors -eq 0 ]] && exit 0 || exit 1
