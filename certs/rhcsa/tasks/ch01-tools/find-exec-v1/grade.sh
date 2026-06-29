#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# no world-writable entries should remain
world_writable=$(find "$TARGET_DIR" -perm /o+w 2>/dev/null)
[[ -z "$world_writable" ]] \
  || fail "world-writable paths still exist: $(echo "$world_writable" | head -3)"

# all regular files must be exactly 0644
while IFS= read -r f; do
  mode=$(stat -c '%a' "$f")
  [[ "$mode" == "644" ]] \
    || fail "file $f has mode $mode, expected 644"
done < <(find "$TARGET_DIR" -type f)

# all directories must be exactly 0755
while IFS= read -r d; do
  mode=$(stat -c '%a' "$d")
  [[ "$mode" == "755" ]] \
    || fail "directory $d has mode $mode, expected 755"
done < <(find "$TARGET_DIR" -type d)

[[ $errors -eq 0 ]] && exit 0 || exit 1
