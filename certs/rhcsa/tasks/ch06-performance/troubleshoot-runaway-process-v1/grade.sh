#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

if pgrep -f rhtr-hog.sh >/dev/null 2>&1; then
  fail "rhtr-hog.sh (or an equivalent runaway process) is still running"
fi

top_pcpu=$(ps -eo pcpu --no-headers | sort -rn | head -1 | tr -d ' ')
awk -v p="$top_pcpu" 'BEGIN{exit !(p+0 < 50)}' || fail "a process is still consuming excessive CPU (${top_pcpu}%)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
