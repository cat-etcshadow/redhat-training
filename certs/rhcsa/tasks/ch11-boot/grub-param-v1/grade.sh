#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

command -v grubby &>/dev/null || fail "grubby is not installed"

grubby --info=DEFAULT 2>/dev/null | grep -q "${KERNEL_PARAM}" \
  || fail "Kernel parameter '${KERNEL_PARAM}' not found in default grub entry"

[[ $errors -eq 0 ]] && exit 0 || exit 1
