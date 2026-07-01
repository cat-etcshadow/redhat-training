#!/usr/bin/env bash
sort "$LOG_FILE" | uniq -c | sort -rn | head -1 | awk '{print $2}' > "$OUTPUT_FILE"
