#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "/etc/systemd/system/${UNIT_NAME}.service" ]] \
  || fail "/etc/systemd/system/${UNIT_NAME}.service does not exist"

grep -qi "ExecStart=.*${UNIT_SCRIPT}" "/etc/systemd/system/${UNIT_NAME}.service" \
  || fail "ExecStart does not reference ${UNIT_SCRIPT} in the unit file"

grep -qi "Type=oneshot" "/etc/systemd/system/${UNIT_NAME}.service" \
  || fail "Type is not set to oneshot"

grep -qi "WantedBy=multi-user.target" "/etc/systemd/system/${UNIT_NAME}.service" \
  || fail "WantedBy is not set to multi-user.target"

systemctl is-enabled "${UNIT_NAME}.service" &>/dev/null \
  || fail "${UNIT_NAME}.service is not enabled at boot (run: systemctl enable ${UNIT_NAME}.service)"

systemctl is-active "${UNIT_NAME}.service" &>/dev/null \
  || fail "${UNIT_NAME}.service is not active (run: systemctl start ${UNIT_NAME}.service)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
