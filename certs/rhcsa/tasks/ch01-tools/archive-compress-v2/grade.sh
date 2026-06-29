#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

ARCHIVE="${ARCHIVE_DIR}/backup.${ARCHIVE_EXT}"

[[ -f "$ARCHIVE" ]] || fail "archive $ARCHIVE does not exist"

case "$ARCHIVE_FORMAT" in
  bzip2)
    file "$ARCHIVE" | grep -qi 'bzip2' || fail "$ARCHIVE is not bzip2 compressed"
    tar -tjf "$ARCHIVE" &>/dev/null    || fail "archive is corrupt or wrong format"
    ;;
  xz)
    file "$ARCHIVE" | grep -qi 'XZ\|xz' || fail "$ARCHIVE is not xz compressed"
    tar -tJf "$ARCHIVE" &>/dev/null       || fail "archive is corrupt or wrong format"
    ;;
esac

for expected in conf/db.conf data/payload.bin MANIFEST; do
  tar -tf "$ARCHIVE" 2>/dev/null | grep -q "$expected" \
    || fail "archive missing expected member: $expected"
done

[[ -d "$EXTRACT_DIR" ]] || fail "extract dir $EXTRACT_DIR does not exist"

SRC_BASENAME=$(basename "$SRC_DIR")
diff -r "$SRC_DIR" "${EXTRACT_DIR}/${SRC_BASENAME}" &>/dev/null \
  || fail "extracted contents differ from source"

[[ $errors -eq 0 ]] && exit 0 || exit 1
