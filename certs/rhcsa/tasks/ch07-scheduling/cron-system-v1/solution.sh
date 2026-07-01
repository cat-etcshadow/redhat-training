#!/usr/bin/env bash
echo "*/${INTERVAL_MIN} * * * * ${CRON_USER} ${SCRIPT_PATH}" > "$CRON_FILE"
chmod 644 "$CRON_FILE"
