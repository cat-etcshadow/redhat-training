#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$CFG_FILE" ]] || fail "ansible.cfg not found at $CFG_FILE"

grep -qE "forks\s*=\s*$FORKS" "$CFG_FILE" \
  || fail "ansible.cfg does not set forks = $FORKS"

grep -qE "log_path\s*=\s*.+" "$CFG_FILE" \
  || fail "ansible.cfg does not set log_path"

grep -q "$LOG_PATH" "$CFG_FILE" \
  || fail "ansible.cfg log_path does not point to $LOG_PATH"

grep -qE "roles_path\s*=\s*.+" "$CFG_FILE" \
  || fail "ansible.cfg does not set roles_path"

grep -qE "collections_paths\s*=\s*.+" "$CFG_FILE" \
  || fail "ansible.cfg does not set collections_paths"

grep -qE "stdout_callback\s*=\s*yaml|callback_whitelist\s*=\s*.*yaml" "$CFG_FILE" \
  || fail "ansible.cfg does not set yaml callback (stdout_callback or callback_whitelist)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
