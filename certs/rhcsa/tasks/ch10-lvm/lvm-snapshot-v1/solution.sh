#!/usr/bin/env bash
lvcreate -L "$SNAP_SIZE" -s -n "$SNAP_NAME" "/dev/${VG_NAME}/${LV_NAME}"
