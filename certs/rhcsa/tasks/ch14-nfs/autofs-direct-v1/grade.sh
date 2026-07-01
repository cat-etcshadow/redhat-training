#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

rpm -q autofs &>/dev/null || fail "autofs is not installed"

[[ -f /etc/auto.master.d/direct.autofs ]] \
  || fail "/etc/auto.master.d/direct.autofs does not exist"
grep -q '/-' /etc/auto.master.d/direct.autofs \
  || fail "master map does not use the direct-map marker '/-'"
grep -q '/etc/auto.direct' /etc/auto.master.d/direct.autofs \
  || fail "master map does not reference /etc/auto.direct"

[[ -f /etc/auto.direct ]] || fail "/etc/auto.direct does not exist"
grep -qF "$MOUNT_PATH" /etc/auto.direct \
  || fail "/etc/auto.direct does not use the full path $MOUNT_PATH as its key"
grep -qF "${NFS_SERVER}:${EXPORT_PATH}" /etc/auto.direct \
  || fail "/etc/auto.direct does not reference ${NFS_SERVER}:${EXPORT_PATH}"

systemctl is-enabled autofs &>/dev/null || fail "autofs service is not enabled"
systemctl is-active  autofs &>/dev/null || fail "autofs service is not running"

[[ $errors -eq 0 ]] && exit 0 || exit 1
