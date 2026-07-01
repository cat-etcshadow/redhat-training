#!/usr/bin/env bash
ps -ef | grep 'rhtr-worker' | grep -v grep | awk '{print $2}' | sort -n > "$REPORT_FILE"
