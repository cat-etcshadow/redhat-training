#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

podman ps --format '{{.Names}}' 2>/dev/null | grep -qw "$CONTAINER_NAME" \
  || fail "Container '$CONTAINER_NAME' is not running"

mem=$(podman inspect "$CONTAINER_NAME" --format '{{.HostConfig.Memory}}' 2>/dev/null)
[[ "$mem" == "$MEM_BYTES" ]] \
  || fail "Container memory limit is $mem bytes, expected $MEM_BYTES ($MEM_LIMIT)"

nano=$(podman inspect "$CONTAINER_NAME" --format '{{.HostConfig.NanoCpus}}' 2>/dev/null)
[[ "$nano" == "$NANO_CPUS" ]] \
  || fail "Container CPU limit is $nano nanocpus, expected $NANO_CPUS (${CPU_LIMIT} CPUs)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
