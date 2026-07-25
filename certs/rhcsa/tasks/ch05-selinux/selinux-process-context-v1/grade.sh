#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; errors=$((errors+1)); }

[[ "$(getenforce)" == "Enforcing" ]] || fail "SELinux is not Enforcing"
systemctl is-active httpd &>/dev/null || fail "httpd is not running"

[[ -f "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE does not exist"

line1=$(sed -n '1p' "$OUTPUT_FILE")
line2=$(sed -n '2p' "$OUTPUT_FILE")

[[ "$line1" == "httpd_t" ]] || fail "line 1 of $OUTPUT_FILE is '$line1', expected httpd_t"
[[ "$line2" == "sshd_t" ]]  || fail "line 2 of $OUTPUT_FILE is '$line2', expected sshd_t"

[[ $errors -eq 0 ]] && exit 0 || exit 1
