#!/usr/bin/env bash
rm -f "$OUTPUT_FILE"
echo "$INFO_MESSAGE" | systemd-cat -t "$SYSLOG_ID" -p info
echo "$ERR_MESSAGE"  | systemd-cat -t "$SYSLOG_ID" -p err
