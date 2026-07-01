#!/usr/bin/env bash
find "$APP_DIR" -perm -4000 -type f > "$REPORT_FILE"
chmod u-s "$APP_DIR/$BAD_BINARY"
