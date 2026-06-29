#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

SRC=/opt/rhtr_safecopy_src.txt
DESTDIR=/opt/rhtr_safecopy_dest
DESTFILE=/opt/rhtr_safecopy_dest/copy.txt

[[ -f "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH does not exist"
[[ -x "$SCRIPT_PATH" ]] || fail "$SCRIPT_PATH is not executable"

# no-arg → exit 1
"$SCRIPT_PATH" &>/dev/null && fail "no-arg should be non-zero" || rc=$?
[[ $rc -eq 1 ]] || fail "no-arg exit code is $rc, expected 1"

# non-existent source → exit 2
"$SCRIPT_PATH" /no/such/file /tmp &>/dev/null && fail "missing src should be non-zero" || rc=$?
[[ $rc -eq 2 ]] || fail "missing source exit code is $rc, expected 2"

# unreadable source → exit 3
touch /opt/rhtr_unreadable && chmod 000 /opt/rhtr_unreadable
"$SCRIPT_PATH" /opt/rhtr_unreadable /tmp &>/dev/null && fail "unreadable should be non-zero" || rc=$?
[[ $rc -eq 3 ]] || fail "unreadable source exit code is $rc, expected 3"
chmod 644 /opt/rhtr_unreadable && rm -f /opt/rhtr_unreadable

# successful copy to a directory
mkdir -p "$DESTDIR"
out=$("$SCRIPT_PATH" "$SRC" "$DESTDIR") && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "copy to dir failed with exit $rc"
[[ -f "${DESTDIR}/rhtr_safecopy_src.txt" ]] \
  || fail "file not copied into directory $DESTDIR"
echo "$out" | grep -qi 'cop' || fail "success output missing 'Copied': $out"

# successful copy to explicit filename
out=$("$SCRIPT_PATH" "$SRC" "$DESTFILE") && rc=0 || rc=$?
[[ $rc -eq 0 ]] || fail "copy to file path failed with exit $rc"
[[ -f "$DESTFILE" ]] || fail "file not created at $DESTFILE"
diff "$SRC" "$DESTFILE" &>/dev/null || fail "copied file content differs from source"

[[ $errors -eq 0 ]] && exit 0 || exit 1
