#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$ERROR_OUTPUT" ]] || fail "error output file $ERROR_OUTPUT does not exist"
[[ -s "$ERROR_OUTPUT" ]] || fail "error output file $ERROR_OUTPUT is empty"

# must capture both ERROR and error (case-insensitive)
grep -qi 'ERROR' "$ERROR_OUTPUT" || fail "$ERROR_OUTPUT does not contain ERROR lines"
grep -qi 'error:' "$ERROR_OUTPUT" || fail "$ERROR_OUTPUT missing lowercase 'error:' line from sys/messages"

[[ -f "$IP_OUTPUT" ]] || fail "IP output file $IP_OUTPUT does not exist"
[[ -s "$IP_OUTPUT" ]] || fail "IP output file $IP_OUTPUT is empty"

# must capture IPv4 addresses across files
grep -qE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' "$IP_OUTPUT" \
  || fail "$IP_OUTPUT does not contain IPv4 addresses"

# spot-check specific expected IPs appear in IP output
for ip in '192.168.1.10' '10.0.0.5' '127.0.0.1'; do
  grep -q "$ip" "$IP_OUTPUT" || fail "$ip not found in $IP_OUTPUT"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
