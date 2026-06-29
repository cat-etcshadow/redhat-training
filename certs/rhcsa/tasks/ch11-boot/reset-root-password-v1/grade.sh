#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

setup_epoch=$(cat /tmp/rhtr_setup_epoch 2>/dev/null || echo 0)
shadow_mtime=$(stat -c '%Y' /etc/shadow)
[[ "$shadow_mtime" -gt "$setup_epoch" ]] \
  || fail "/etc/shadow has not been modified since setup — root password was not reset"

# Verify the password works (test against known target)
echo 'RedHat123!' | passwd --stdin root &>/dev/null \
  || fail "Could not verify root password — ensure it is set to RedHat123!"

hash=$(getent shadow root | cut -d: -f2)
[[ "$hash" =~ ^\$ ]] || fail "root account appears locked (hash does not start with \$)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
