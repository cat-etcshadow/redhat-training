#!/usr/bin/env bash
journalctl -t "$SYSLOG_ID" --since "$SINCE_TS" --no-pager > "$OUTPUT_FILE"
