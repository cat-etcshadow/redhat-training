#!/usr/bin/env bash
dnf install -y grubby &>/dev/null
# Remove the param if it was previously added
grubby --update-kernel=DEFAULT --remove-args="$KERNEL_PARAM" 2>/dev/null || true
