#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SWAP_FILE" ]] || fail "$SWAP_FILE does not exist"

perm=$(stat -c '%a' "$SWAP_FILE" 2>/dev/null || echo "")
[[ "$perm" == "600" ]] || fail "$SWAP_FILE permissions are $perm, expected 600"

swapon --show --noheadings 2>/dev/null | awk '{print $1}' | grep -qx "$SWAP_FILE" \
  || fail "$SWAP_FILE is not active as swap"

grep -qE "^${SWAP_FILE}[[:space:]]+none[[:space:]]+swap" /etc/fstab \
  || fail "no persistent swap entry for $SWAP_FILE in /etc/fstab"

[[ $errors -eq 0 ]] && exit 0 || exit 1
