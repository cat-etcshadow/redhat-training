#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$SCRIPT_FILE" ]] || fail "script $SCRIPT_FILE not found"
[[ -x "$SCRIPT_FILE" ]] || fail "script $SCRIPT_FILE is not executable"

grep -q "ansible" "$SCRIPT_FILE"         || fail "script does not call ansible"
grep -q "ping"    "$SCRIPT_FILE"         || fail "script does not use ping module"
grep -q "package\|dnf\|yum" "$SCRIPT_FILE" || fail "script does not use package/dnf/yum module"
grep -q "$INSTALL_PKG" "$SCRIPT_FILE"   || fail "script does not reference $INSTALL_PKG"
grep -q "command\|hostname" "$SCRIPT_FILE" || fail "script does not use command module or hostname"
grep -q "prod"  "$SCRIPT_FILE"           || fail "script does not target prod group"

[[ $errors -eq 0 ]] && exit 0 || exit 1
