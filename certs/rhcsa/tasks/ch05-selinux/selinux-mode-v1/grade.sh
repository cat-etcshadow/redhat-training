#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# current runtime mode must be Enforcing
mode=$(getenforce)
[[ "$mode" == "Enforcing" ]] \
  || fail "SELinux runtime mode is '$mode', expected 'Enforcing'"

# /etc/selinux/config must have SELINUX=enforcing
grep -qiE '^\s*SELINUX\s*=\s*enforcing' /etc/selinux/config \
  || fail "/etc/selinux/config does not have SELINUX=enforcing (not persistent)"

# output file must exist and contain sestatus output
[[ -f "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE does not exist"
[[ -s "$OUTPUT_FILE" ]] || fail "$OUTPUT_FILE is empty"

grep -qi 'selinux status\|selinuxfs mount\|Current mode' "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE missing sestatus output"

# must contain a file context listing
grep -qiE 'system_u|unconfined_u|passwd|sshd' "$OUTPUT_FILE" \
  || fail "$OUTPUT_FILE missing file context output (ls -Z)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
