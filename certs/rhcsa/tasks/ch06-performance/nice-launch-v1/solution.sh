#!/usr/bin/env bash
renice "$NICE_VAL" -u "$TARGET_USER"
