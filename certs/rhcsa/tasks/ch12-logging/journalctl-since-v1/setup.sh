#!/usr/bin/env bash
rm -f "$OUTPUT_FILE"
echo "$DECOY_MESSAGE" | systemd-cat -t "$SYSLOG_ID"

# Wait until the SINCE_TS boundary has actually passed, regardless of how
# long the gap between param generation and this setup run turned out to
# be, then log the message that must survive the --since filter.
while [[ $(date +%s) -lt $(date -d "$SINCE_TS" +%s) ]]; do sleep 1; done
sleep 1
echo "$KEEP_MESSAGE" | systemd-cat -t "$SYSLOG_ID"
sleep 1
