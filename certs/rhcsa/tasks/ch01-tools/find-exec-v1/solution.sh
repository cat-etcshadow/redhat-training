#!/usr/bin/env bash
find "$TARGET_DIR" -type f -exec chmod 0644 {} +
find "$TARGET_DIR" -type d -exec chmod 0755 {} +
