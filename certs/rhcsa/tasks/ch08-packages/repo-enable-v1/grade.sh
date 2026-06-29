#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

repo_file=$(grep -rl '^\[extras\]' /etc/yum.repos.d/ 2>/dev/null | head -1)
[[ -n "$repo_file" ]] || fail "No repo file found containing [extras]"

enabled=$(grep -A5 '^\[extras\]' "$repo_file" | grep '^enabled' | awk -F= '{print $2}' | tr -d ' ')
[[ "$enabled" == "1" ]] \
  || fail "extras repo is not enabled in $repo_file (enabled=$enabled)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
