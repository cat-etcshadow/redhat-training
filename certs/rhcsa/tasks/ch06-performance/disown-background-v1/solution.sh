#!/usr/bin/env bash
/usr/local/bin/rhtr-worker2.sh > "$LOG_FILE" 2>/dev/null &
disown
