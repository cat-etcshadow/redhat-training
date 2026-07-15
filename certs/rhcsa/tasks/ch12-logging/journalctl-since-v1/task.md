## Filter journal entries by an absolute start time

The identifier **{{SYSLOG_ID}}** has logged messages both before and at (or after) **{{SINCE_TS}}**. Using `journalctl`, retrieve only the entries for **{{SYSLOG_ID}}** logged at or after **{{SINCE_TS}}**, and save the output to **{{OUTPUT_FILE}}**; messages logged before that time must not appear in the output.
