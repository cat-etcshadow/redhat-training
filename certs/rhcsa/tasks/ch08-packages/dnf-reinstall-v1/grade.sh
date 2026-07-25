#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

rpm -q httpd &>/dev/null || fail "httpd is not installed"

grep -q "corrupted by accident" /etc/httpd/conf/httpd.conf 2>/dev/null \
  && fail "/etc/httpd/conf/httpd.conf still contains the corrupted content"

diffs=$(rpm -V httpd-core 2>/dev/null | grep 'httpd.conf' || true)
[[ -z "$diffs" ]] \
  || fail "/etc/httpd/conf/httpd.conf still differs from the package-provided version: $diffs"

[[ $errors -eq 0 ]] && exit 0 || exit 1
