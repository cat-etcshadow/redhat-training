#!/usr/bin/env bash
mkdir -p "$EXTRACT_DIR"
tar -xzf "$ARCHIVE" -C "$EXTRACT_DIR" "$TARGET_FILE"
