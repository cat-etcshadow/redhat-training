#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

rpm -q podman &>/dev/null || fail "podman is not installed"

# Check container is running (either root or rootless)
running=$(podman ps --format '{{.Names}}' 2>/dev/null)
echo "$running" | grep -q '^webserver$' || fail "Container 'webserver' is not running"

port_map=$(podman inspect webserver --format '{{.HostConfig.PortBindings}}' 2>/dev/null)
echo "$port_map" | grep -q '8080' || fail "Port 8080 is not mapped on the host"

env_vars=$(podman inspect webserver --format '{{.Config.Env}}' 2>/dev/null)
echo "$env_vars" | grep -q 'APP_ENV=production' \
  || fail "APP_ENV=production not set in container environment"

[[ $errors -eq 0 ]] && exit 0 || exit 1
