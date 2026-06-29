#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

command -v podman &>/dev/null || fail "podman is not installed"

podman ps --format '{{.Names}}' 2>/dev/null | grep -qw "$CONTAINER_NAME" \
  || fail "Container '$CONTAINER_NAME' is not running (check 'podman ps')"

podman inspect "$CONTAINER_NAME" --format '{{range .Config.Env}}{{.}} {{end}}' 2>/dev/null \
  | grep -q "${ENV_KEY}=${ENV_VAL}" \
  || fail "Container env does not contain ${ENV_KEY}=${ENV_VAL}"

podman inspect "$CONTAINER_NAME" \
  --format '{{range $k,$v := .HostConfig.PortBindings}}{{$k}} {{range $v}}{{.HostPort}}{{end}} {{end}}' \
  2>/dev/null | grep -q "${HOST_PORT}" \
  || fail "Port mapping ${HOST_PORT}->8080 not found in container config"

[[ $errors -eq 0 ]] && exit 0 || exit 1
