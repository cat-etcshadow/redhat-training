#!/usr/bin/env bash
dnf install -y grubby &>/dev/null
grubby --update-kernel=DEFAULT --remove-args="$KERNEL_PARAM" 2>/dev/null || true
grubby --update-kernel=DEFAULT --args="$KERNEL_PARAM"
