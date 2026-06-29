#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

ARCHIVE="${ARCHIVE_DIR}/${ARCHIVE_NAME}"

[[ -f "$ARCHIVE" ]] || fail "archive $ARCHIVE does not exist"

file "$ARCHIVE" 2>/dev/null | grep -qi 'gzip\|tar' \
  || fail "$ARCHIVE is not a gzip-compressed archive"

tar -tzf "$ARCHIVE" &>/dev/null \
  || fail "$ARCHIVE cannot be listed — may be corrupt"

for expected in config.conf README.txt subdir/data.dat subdir/notes.txt; do
  tar -tzf "$ARCHIVE" 2>/dev/null | grep -q "$expected" \
    || fail "$ARCHIVE is missing expected member: $expected"
done

SRC_BASENAME=$(basename "$SRC_DIR")
EXTRACTED_DIR="${EXTRACT_DIR}/${SRC_BASENAME}"

[[ -d "$EXTRACT_DIR" ]] || fail "extract dir $EXTRACT_DIR does not exist"

[[ -f "${EXTRACTED_DIR}/config.conf" ]]      || fail "extracted config.conf missing"
[[ -f "${EXTRACTED_DIR}/README.txt" ]]       || fail "extracted README.txt missing"
[[ -f "${EXTRACTED_DIR}/subdir/data.dat" ]]  || fail "extracted subdir/data.dat missing"
[[ -f "${EXTRACTED_DIR}/subdir/notes.txt" ]] || fail "extracted subdir/notes.txt missing"

diff -r "$SRC_DIR" "$EXTRACTED_DIR" &>/dev/null \
  || fail "extracted contents differ from source"

[[ $errors -eq 0 ]] && exit 0 || exit 1
