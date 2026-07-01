#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

repo_file=$(grep -rl "$REPO_URL" /etc/yum.repos.d/ 2>/dev/null | head -1)
[[ -n "$repo_file" ]] || fail "No repo file in /etc/yum.repos.d found referencing $REPO_URL"

if [[ -n "$repo_file" ]]; then
  grep -A5 "$REPO_URL" "$repo_file" | grep -q '^gpgcheck=0' \
    || grep -B5 "$REPO_URL" "$repo_file" | grep -q '^gpgcheck=0' \
    || fail "$repo_file does not have gpgcheck=0 for this repo"
fi

rpm -q "$PKG" &>/dev/null || fail "$PKG is not installed"

[[ $errors -eq 0 ]] && exit 0 || exit 1
