#!/usr/bin/env bash
(
  echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${TOOL_DIR}"
  echo "*/5 * * * * ${SCRIPT_PATH}"
) | crontab -u "$CRON_USER" -
