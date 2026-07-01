#!/usr/bin/env bash
nohup /usr/local/bin/rhtr-worker.sh > "$LOG_FILE" 2>/dev/null &
