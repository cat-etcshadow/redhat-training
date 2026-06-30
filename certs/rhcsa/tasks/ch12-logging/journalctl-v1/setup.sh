#!/usr/bin/env bash
rm -f "$OUTPUT_FILE" "$BOOT_LOG_FILE"
for i in $(seq 5); do
  echo "$LOG_MESSAGE (instance $i)" | systemd-cat -t "$SYSLOG_ID" -p info
done
