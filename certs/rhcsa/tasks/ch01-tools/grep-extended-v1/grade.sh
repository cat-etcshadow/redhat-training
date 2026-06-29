#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$OUTPUT_USERS" ]] || fail "$OUTPUT_USERS does not exist"
[[ -s "$OUTPUT_USERS" ]] || fail "$OUTPUT_USERS is empty"

# every line in OUTPUT_USERS must end with the target shell
while IFS= read -r line; do
  [[ "$line" =~ /bin/${TARGET_SHELL}$ ]] \
    || fail "line does not end with /bin/${TARGET_SHELL}: $line"
done < "$OUTPUT_USERS"

# should have exactly 3 matching users (alice, carol, eve)
count=$(wc -l < "$OUTPUT_USERS")
(( count == 3 )) || fail "expected 3 matching users, found $count"

[[ -f "$OUTPUT_NAMES" ]] || fail "$OUTPUT_NAMES does not exist"
[[ -s "$OUTPUT_NAMES" ]] || fail "$OUTPUT_NAMES is empty"

# names file must contain no colons
grep -q ':' "$OUTPUT_NAMES" && fail "$OUTPUT_NAMES contains colons — should be usernames only" || true

for user in alice carol eve; do
  grep -qx "$user" "$OUTPUT_NAMES" || fail "username $user missing from $OUTPUT_NAMES"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
