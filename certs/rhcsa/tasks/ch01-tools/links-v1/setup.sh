#!/usr/bin/env bash
mkdir -p "$(dirname "$TARGET_FILE")"
rm -f "$HARD_LINK" "$SOFT_LINK"
echo "original content line 1" > "$TARGET_FILE"
echo "original content line 2" >> "$TARGET_FILE"
