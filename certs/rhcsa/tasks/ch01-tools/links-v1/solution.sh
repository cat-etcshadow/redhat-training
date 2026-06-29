#!/usr/bin/env bash
ln    "$TARGET_FILE" "$HARD_LINK"
ln -s "$SOFT_TARGET" "$SOFT_LINK"
