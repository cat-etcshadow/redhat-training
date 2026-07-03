#!/usr/bin/env bash
grubby --update-kernel=DEFAULT --remove-args="$KERNEL_PARAM"
