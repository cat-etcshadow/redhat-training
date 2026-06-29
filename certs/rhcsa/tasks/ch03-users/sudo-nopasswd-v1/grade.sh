#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

ls /etc/sudoers.d/ | grep -qi "$SUDO_USER" \
  || fail "no sudoers drop-in file for $SUDO_USER found in /etc/sudoers.d/"

visudo -c &>/dev/null || fail "sudoers files contain syntax errors (visudo -c failed)"

sudo_out=$(sudo -l -U "$SUDO_USER" 2>/dev/null)
cmd1_base=$(basename "$CMD1")
cmd2_base=$(basename "$CMD2")

echo "$sudo_out" | grep -q "NOPASSWD.*${cmd1_base}\|NOPASSWD.*ALL" \
  || fail "$SUDO_USER cannot run $CMD1 without password"
echo "$sudo_out" | grep -q "NOPASSWD.*${cmd2_base}\|NOPASSWD.*ALL" \
  || fail "$SUDO_USER cannot run $CMD2 without password"

[[ $errors -eq 0 ]] && exit 0 || exit 1
