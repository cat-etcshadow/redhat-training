#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

SRC=/opt/rhtr_backup_src.conf
DESTDIR=/opt/rhtr_backup_dest

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# too few args → exit 1
"$SCRIPT_PATH" &>/dev/null && fail "no-arg should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "no-arg exit code is $rc, expected 1"

"$SCRIPT_PATH" one_arg &>/dev/null && fail "one-arg should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "one-arg exit code is $rc, expected 1"

# non-existent source → exit 2
"$SCRIPT_PATH" /no/such/file "$DESTDIR" &>/dev/null && fail "bad src should be non-zero" || rc=$?
[[ $rc -eq 2 ]] || fail "non-existent source exit code is $rc, expected 2"

# successful backup — dest dir does not pre-exist
rm -rf "$DESTDIR"
out=$("$SCRIPT_PATH" "$SRC" "$DESTDIR") && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "script failed with exit code $rc on valid run"

[[ -d "$DESTDIR" ]] || fail "$DESTDIR was not created"

# find the backup file (name contains datestamp suffix)
backup_count=$(find "$DESTDIR" -maxdepth 1 -name 'rhtr_backup_src.conf.*' | wc -l)
(( backup_count >= 1 )) \
  || fail "no backup file matching rhtr_backup_src.conf.<timestamp> found in $DESTDIR"

# content must match
backup_file=$(find "$DESTDIR" -maxdepth 1 -name 'rhtr_backup_src.conf.*' | head -1)
diff "$SRC" "$backup_file" &>/dev/null \
  || fail "backup file content differs from source"

[[ $errors -eq 0 ]] && exit 0 || exit 1
