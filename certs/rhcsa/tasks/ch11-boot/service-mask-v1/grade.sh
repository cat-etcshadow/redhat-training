#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

state=$(systemctl is-enabled "${UNIT_NAME}.service" 2>&1 || true)
[[ "$state" == "masked" ]] \
  || fail "$UNIT_NAME.service is not masked (state: $state)"

systemctl start "${UNIT_NAME}.service" &>/dev/null \
  && fail "$UNIT_NAME.service could still be started despite being masked"

[[ $errors -eq 0 ]] && exit 0 || exit 1
