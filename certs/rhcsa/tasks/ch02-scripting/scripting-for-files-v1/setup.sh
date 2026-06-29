#!/usr/bin/env bash
rm -f "$SCRIPT_PATH"
rm -rf "$LOG_DIR" "$ARCHIVE_DIR"
mkdir -p "$LOG_DIR"
for name in app access error system; do
  echo "$(date) log entry from $name" > "${LOG_DIR}/${name}.log"
  echo "$(date) another line"        >> "${LOG_DIR}/${name}.log"
done
echo "not a log" > "${LOG_DIR}/readme.txt"
