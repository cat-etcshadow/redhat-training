#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

if ! rpm -q tree &>/dev/null; then
  dnf install -y tree &>/tmp/rhtr-dnf-check || true
fi
if ! rpm -q tree &>/dev/null; then
  fail "dnf install still fails: $(tail -5 /tmp/rhtr-dnf-check 2>/dev/null)"
fi
rm -f /tmp/rhtr-dnf-check

[[ $errors -eq 0 ]] && exit 0 || exit 1
