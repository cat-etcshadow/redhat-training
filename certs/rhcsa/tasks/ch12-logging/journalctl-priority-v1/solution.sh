#!/usr/bin/env bash
journalctl -t "$SYSLOG_ID" -p err --no-pager > "$OUTPUT_FILE"
