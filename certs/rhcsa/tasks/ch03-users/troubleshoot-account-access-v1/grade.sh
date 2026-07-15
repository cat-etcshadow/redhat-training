#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

if ! su -s /bin/sh - devuser -c 'true' 2>/tmp/rhtr-su-check; then
  fail "devuser still cannot log in: $(cat /tmp/rhtr-su-check 2>/dev/null)"
fi
rm -f /tmp/rhtr-su-check

[[ $errors -eq 0 ]] && exit 0 || exit 1
