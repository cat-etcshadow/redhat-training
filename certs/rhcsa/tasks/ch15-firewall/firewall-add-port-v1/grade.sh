#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

firewall-cmd --permanent --zone=public --list-ports 2>/dev/null | grep -q "${TCP_PORT}/tcp" \
  || fail "Port ${TCP_PORT}/tcp not permanently open in public zone"

firewall-cmd --permanent --zone=public --list-ports 2>/dev/null | grep -q "${UDP_START}-${UDP_END}/udp" \
  || fail "Port range ${UDP_START}-${UDP_END}/udp not permanently open in public zone"

[[ $errors -eq 0 ]] && exit 0 || exit 1
