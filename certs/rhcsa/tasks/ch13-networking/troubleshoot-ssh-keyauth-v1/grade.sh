#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

if ! su - sshadmin -c "ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 -i ~/.ssh/id_rsa sshadmin@localhost true" &>/tmp/rhtr-ssh-check; then
  fail "sshadmin still cannot log in via SSH key: $(tail -5 /tmp/rhtr-ssh-check 2>/dev/null)"
fi
rm -f /tmp/rhtr-ssh-check

[[ $errors -eq 0 ]] && exit 0 || exit 1
