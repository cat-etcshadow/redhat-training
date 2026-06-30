#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

setup_epoch=$(cat /tmp/rhtr_setup_epoch 2>/dev/null || echo 0)
shadow_mtime=$(stat -c '%Y' /etc/shadow)
[[ "$shadow_mtime" -gt "$setup_epoch" ]] \
  || fail "/etc/shadow has not been modified since setup — root password was not reset"

hash=$(getent shadow root | cut -d: -f2)
[[ "$hash" =~ ^\$ ]] || fail "root account appears locked (hash does not start with \$)"

python3 - "$hash" <<'PY' || fail "root password is not 'RedHat123!' — set it exactly as shown"
import crypt, sys
h = sys.argv[1]
sys.exit(0 if crypt.crypt('RedHat123!', h) == h else 1)
PY

[[ $errors -eq 0 ]] && exit 0 || exit 1
