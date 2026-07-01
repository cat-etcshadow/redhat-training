#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

firewall-cmd --permanent --zone=public --list-services 2>/dev/null | grep -qw "$SVC_NAME" \
  && fail "$SVC_NAME is still permanently enabled in the public zone"

firewall-cmd --zone=public --list-services 2>/dev/null | grep -qw "$SVC_NAME" \
  && fail "$SVC_NAME is still active in the public zone — was 'firewall-cmd --reload' run?"

[[ $errors -eq 0 ]] && exit 0 || exit 1
