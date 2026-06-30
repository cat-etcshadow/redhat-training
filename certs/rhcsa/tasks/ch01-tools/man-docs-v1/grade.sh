#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$DEST_FILE" ]] \
  || fail "$DEST_FILE does not exist — copy /etc/hosts with archive mode (cp -a)"

orig_mtime=$(stat -c '%Y' /etc/hosts)
dest_mtime=$(stat -c '%Y' "$DEST_FILE")
[[ "$orig_mtime" == "$dest_mtime" ]] \
  || fail "$DEST_FILE mtime does not match /etc/hosts — use 'cp -a' or 'cp --archive' to preserve timestamps"

diff /etc/hosts "$DEST_FILE" &>/dev/null \
  || fail "$DEST_FILE content differs from /etc/hosts"

[[ -f "$OUTPUT_FILE" ]] \
  || fail "$OUTPUT_FILE does not exist — run: find /var/log -size +1M > $OUTPUT_FILE"

grep -q '/var/log' "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE does not contain /var/log paths — check your find command"

grep -q '/var/log/rhtr-test.log' "$OUTPUT_FILE" \
  || fail "find did not find the 3 MB test file in /var/log — use: find /var/log -size +1M"

[[ $errors -eq 0 ]] && exit 0 || exit 1
