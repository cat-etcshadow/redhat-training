#!/usr/bin/env bash
rm -f "/etc/logrotate.d/${APP_NAME}"
echo "log entry $(date)" > "$LOG_FILE"
