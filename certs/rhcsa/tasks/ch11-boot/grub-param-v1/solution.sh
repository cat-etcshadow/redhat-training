#!/usr/bin/env bash
grubby --update-kernel=DEFAULT --args="$KERNEL_PARAM"
grubby --info=DEFAULT
