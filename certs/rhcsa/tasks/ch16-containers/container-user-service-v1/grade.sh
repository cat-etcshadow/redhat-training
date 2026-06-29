#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# linger must be enabled
linger=$(loginctl show-user "$CTR_USER" 2>/dev/null | grep '^Linger=' | cut -d= -f2)
[[ "$linger" == "yes" ]] \
  || fail "loginctl linger is '$linger' for $CTR_USER, expected 'yes'"

# user service must be enabled
su - "$CTR_USER" -c "systemctl --user is-enabled container-${CTR_NAME}.service" &>/dev/null \
  || fail "container-${CTR_NAME}.service is not enabled for user $CTR_USER"

# user service must be active
su - "$CTR_USER" -c "systemctl --user is-active container-${CTR_NAME}.service" &>/dev/null \
  || fail "container-${CTR_NAME}.service is not active for user $CTR_USER"

# container must be running
running=$(su - "$CTR_USER" -c "podman ps --format '{{.Names}}'" 2>/dev/null || true)
echo "$running" | grep -q "$CTR_NAME" \
  || fail "container '$CTR_NAME' is not running for user $CTR_USER"

# service unit file must exist in user's config
[[ -f "/home/${CTR_USER}/.config/systemd/user/container-${CTR_NAME}.service" ]] \
  || fail "service unit ~/.config/systemd/user/container-${CTR_NAME}.service missing"

[[ $errors -eq 0 ]] && exit 0 || exit 1
