#!/usr/bin/env bash
set -euo pipefail
errors=0

fail() { echo "FAIL: $*"; (( errors++ )); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"

# Current value must be on
current=$(getsebool httpd_can_network_connect 2>/dev/null | awk '{print $3}')
[[ "$current" == "on" ]] \
  || fail "httpd_can_network_connect is $current, expected on"

# Must be persistent (stored in policy — getsebool shows both runtime and persistent)
persistent=$(semanage boolean -l 2>/dev/null \
  | awk '/httpd_can_network_connect/{print $3}' | tr -d ',')
[[ "$persistent" == "on" ]] \
  || fail "httpd_can_network_connect persistent value is $persistent — use setsebool -P"

[[ $errors -eq 0 ]] && exit 0 || exit 1
