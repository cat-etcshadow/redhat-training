#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

podman network exists "$NET_NAME" &>/dev/null \
  || fail "podman network '$NET_NAME' does not exist"

podman ps --format '{{.Names}}' 2>/dev/null | grep -qw "$CONTAINER_NAME" \
  || fail "Container '$CONTAINER_NAME' is not running"

used_net=$(podman inspect "$CONTAINER_NAME" \
  --format '{{range $k,$v := .NetworkSettings.Networks}}{{$k}}{{end}}' 2>/dev/null)
[[ "$used_net" == "$NET_NAME" ]] \
  || fail "Container '$CONTAINER_NAME' is attached to network '$used_net', expected '$NET_NAME'"

ip_addr=$(podman inspect "$CONTAINER_NAME" \
  --format '{{range $k,$v := .NetworkSettings.Networks}}{{$v.IPAddress}}{{end}}' 2>/dev/null)
[[ -n "$ip_addr" ]] || fail "Container '$CONTAINER_NAME' has no IP address assigned"

python3 -c "
import ipaddress, sys
sys.exit(0 if ipaddress.ip_address('${ip_addr}') in ipaddress.ip_network('${SUBNET}') else 1)
" || fail "Container IP $ip_addr is not within subnet $SUBNET"

[[ $errors -eq 0 ]] && exit 0 || exit 1
