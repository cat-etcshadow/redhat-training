#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

id "$DEL_USER" &>/dev/null && fail "user $DEL_USER still exists" || true

[[ ! -d "/home/${DEL_USER}" ]] \
  || fail "home directory /home/${DEL_USER} still exists"

getent group "$DEL_GROUP" &>/dev/null && fail "group $DEL_GROUP still exists" || true

[[ ! -f "/etc/sudoers.d/${DEL_USER}" ]] \
  || fail "/etc/sudoers.d/${DEL_USER} still exists"

# no owned files should remain (search common locations)
owned=$(find /home /tmp /var/spool/mail -maxdepth 3 -user "$DEL_USER" 2>/dev/null | head -3 || true)
[[ -z "$owned" ]] || fail "files still owned by $DEL_USER found: $owned"

[[ $errors -eq 0 ]] && exit 0 || exit 1
