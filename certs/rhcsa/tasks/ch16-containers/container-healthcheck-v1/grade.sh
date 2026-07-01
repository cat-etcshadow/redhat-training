#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

command -v podman &>/dev/null || fail "podman is not installed"

podman ps --format '{{.Names}}' 2>/dev/null | grep -qw "$CONTAINER_NAME" \
  || fail "Container '$CONTAINER_NAME' is not running"

hc_len=$(podman inspect "$CONTAINER_NAME" --format '{{len .Config.Healthcheck.Test}}' 2>/dev/null || echo 0)
[[ "$hc_len" -gt 0 ]] \
  || fail "Container '$CONTAINER_NAME' has no health check configured"

sleep 5
status=$(podman inspect "$CONTAINER_NAME" --format '{{.State.Health.Status}}' 2>/dev/null)
[[ "$status" == "healthy" ]] \
  || fail "Container '$CONTAINER_NAME' health status is '$status', expected 'healthy'"

[[ $errors -eq 0 ]] && exit 0 || exit 1
