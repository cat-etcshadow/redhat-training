#!/usr/bin/env bash
journalctl -t "$SYSLOG_ID" --no-pager > "$OUTPUT_FILE"
journalctl -b --no-pager > "$BOOT_LOG_FILE"
