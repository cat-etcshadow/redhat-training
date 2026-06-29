#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

semanage port -l 2>/dev/null | grep -q "http_port_t.*tcp.*\b${HTTP_PORT}\b" \
  || fail "Port $HTTP_PORT/tcp is not assigned to SELinux http_port_t"

systemctl is-active httpd &>/dev/null || fail "httpd is not running"

systemctl is-enabled httpd &>/dev/null || fail "httpd is not enabled"

grep -q "^Listen ${HTTP_PORT}" /etc/httpd/conf/httpd.conf \
  || fail "httpd is not configured to Listen on $HTTP_PORT"

code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:${HTTP_PORT}" 2>/dev/null)
[[ "$code" != "000" ]] \
  || fail "Could not connect to httpd on port $HTTP_PORT (curl returned 000)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
