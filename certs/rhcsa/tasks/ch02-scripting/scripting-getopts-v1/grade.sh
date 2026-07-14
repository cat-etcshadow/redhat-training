#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

SRC=/opt/rhtr_getopts_src.conf
DEST1=/opt/rhtr_getopts_dest1

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no flags at all -> exit 1
"$SCRIPT_PATH" &>/dev/null && fail "no-flag invocation should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "no-flag exit code is $rc, expected 1"

# -s only, missing -d -> exit 1
"$SCRIPT_PATH" -s "$SRC" &>/dev/null && fail "missing -d should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "missing -d exit code is $rc, expected 1"

# non-existent source -> exit 2
"$SCRIPT_PATH" -s /no/such/file -d "$DEST1" &>/dev/null && fail "bad src should be non-zero" || rc=$?
[[ $rc -eq 2 ]] || fail "non-existent source exit code is $rc, expected 2"

# valid run
rm -rf "$DEST1"
out=$("$SCRIPT_PATH" -s "$SRC" -d "$DEST1") && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "valid run exited $rc, expected 0"
[[ -f "$DEST1/rhtr_getopts_src.conf" ]] || fail "$DEST1/rhtr_getopts_src.conf was not created"
diff "$SRC" "$DEST1/rhtr_getopts_src.conf" &>/dev/null || fail "copied file content differs from source"
echo "$out" | grep -q "Backup complete" || fail "missing 'Backup complete' in output"

[[ $errors -eq 0 ]] && exit 0 || exit 1
