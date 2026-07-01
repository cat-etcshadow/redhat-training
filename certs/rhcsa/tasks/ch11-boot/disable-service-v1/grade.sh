#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

systemctl is-active "${UNIT_NAME}.service" &>/dev/null \
  && fail "$UNIT_NAME.service is still running"

systemctl is-enabled "${UNIT_NAME}.service" &>/dev/null \
  && fail "$UNIT_NAME.service is still enabled"

[[ $errors -eq 0 ]] && exit 0 || exit 1
