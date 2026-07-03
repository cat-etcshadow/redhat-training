#!/usr/bin/env bash
( crontab -l -u "$CRON_USER" 2>/dev/null; echo "$CRON_MIN $CRON_HOUR * * $DOW_PATTERN $CRON_SCRIPT" ) \
  | crontab -u "$CRON_USER" -
