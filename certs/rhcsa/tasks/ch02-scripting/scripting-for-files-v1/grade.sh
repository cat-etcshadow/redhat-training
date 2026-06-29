#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no-arg check
"$SCRIPT_PATH" &>/dev/null && fail "no-arg should exit non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "no-arg exit code is $rc, expected 1"

# run the script
"$SCRIPT_PATH" "$LOG_DIR" "$ARCHIVE_DIR" || fail "script failed when run with valid args"

[[ -d "$ARCHIVE_DIR" ]] || fail "$ARCHIVE_DIR was not created"

for name in app access error system; do
  gz="${ARCHIVE_DIR}/${name}.log.gz"
  [[ -f "$gz" ]] || fail "expected $gz not found in archive dir"
  file "$gz" | grep -qi 'gzip' || fail "$gz is not a valid gzip file"
  # contents must match original
  orig_sum=$(md5sum "${LOG_DIR}/${name}.log" | awk '{print $1}')
  ext_sum=$(zcat "$gz" | md5sum | awk '{print $1}')
  [[ "$orig_sum" == "$ext_sum" ]] \
    || fail "$gz contents don't match original ${name}.log"
done

# readme.txt must NOT be archived
[[ ! -f "${ARCHIVE_DIR}/readme.txt.gz" ]] \
  || fail "readme.txt.gz should not be in archive (only .log files)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
