#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$OUTPUT_FILE" ]] || fail "output file $OUTPUT_FILE does not exist"

expected_count=5
actual_count=$(grep -c "\.${FILE_EXT}$" "$OUTPUT_FILE" 2>/dev/null || echo 0)
(( actual_count >= expected_count )) \
  || fail "expected $expected_count .${FILE_EXT} files in output, found $actual_count"

# no non-matching extensions should appear
if grep -vE "\.${FILE_EXT}$" "$OUTPUT_FILE" | grep -q .; then
  fail "output contains non-.${FILE_EXT} entries"
fi

# all entries must be regular files (not dirs or symlinks)
while IFS= read -r path; do
  [[ -f "$path" && ! -L "$path" ]] \
    || fail "$path is not a regular file — directories/symlinks must be excluded"
done < "$OUTPUT_FILE"

# check specific expected files are present
for expected in \
    "${SEARCH_DIR}/file1.${FILE_EXT}" \
    "${SEARCH_DIR}/subA/nested.${FILE_EXT}" \
    "${SEARCH_DIR}/subA/subB/deep.${FILE_EXT}"; do
  grep -qF "$expected" "$OUTPUT_FILE" \
    || fail "expected path $expected not found in output"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
