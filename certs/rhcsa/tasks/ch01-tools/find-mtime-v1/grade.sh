#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ -d "$ARCHIVE_DIR" ]] || fail "$ARCHIVE_DIR does not exist"

for f in old1.log old2.log old3.log; do
  [[ -f "$ARCHIVE_DIR/$f" ]] || fail "$f was not moved into $ARCHIVE_DIR"
  [[ -f "$SEARCH_DIR/$f" ]]  && fail "$f is still present in $SEARCH_DIR, should have been moved"
done

for f in new1.log new2.log; do
  [[ -f "$SEARCH_DIR/$f" ]]  || fail "$f is missing from $SEARCH_DIR, it should not have been moved"
  [[ -f "$ARCHIVE_DIR/$f" ]] && fail "$f should not have been archived (it is not old enough)"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
