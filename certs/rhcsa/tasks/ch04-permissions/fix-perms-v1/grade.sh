#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# root dir group and mode
root_group=$(stat -c '%G' "$WEB_ROOT")
[[ "$root_group" == "$WEB_GROUP" ]] \
  || fail "$WEB_ROOT group is '$root_group', expected '$WEB_GROUP'"

root_mode=$(stat -c '%a' "$WEB_ROOT")
[[ "$root_mode" == "2775" ]] \
  || fail "$WEB_ROOT mode is $root_mode, expected 2775"

# all dirs
while IFS= read -r d; do
  g=$(stat -c '%G' "$d")
  m=$(stat -c '%a' "$d")
  [[ "$g" == "$WEB_GROUP" ]] || fail "dir $d group is '$g', expected '$WEB_GROUP'"
  [[ "$m" == "2775" ]]       || fail "dir $d mode is $m, expected 2775"
done < <(find "$WEB_ROOT" -type d)

# all files
while IFS= read -r f; do
  g=$(stat -c '%G' "$f")
  m=$(stat -c '%a' "$f")
  [[ "$g" == "$WEB_GROUP" ]] || fail "file $f group is '$g', expected '$WEB_GROUP'"
  [[ "$m" == "664" ]]        || fail "file $f mode is $m, expected 664"
done < <(find "$WEB_ROOT" -type f)

[[ $errors -eq 0 ]] && exit 0 || exit 1
