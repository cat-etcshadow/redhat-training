#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

command -v node &>/dev/null || fail "nodejs is not installed (node command not found)"

node_ver=$(node --version 2>/dev/null | tr -d 'v')
major=${node_ver%%.*}
[[ "$major" == "$NODE_STREAM" ]] \
  || fail "node version is v${node_ver}, expected v${NODE_STREAM}.x"

dnf module list nodejs 2>/dev/null | grep -q "${NODE_STREAM}.*\[e\]" \
  || fail "nodejs:${NODE_STREAM} stream is not marked as enabled in dnf"

[[ $errors -eq 0 ]] && exit 0 || exit 1
