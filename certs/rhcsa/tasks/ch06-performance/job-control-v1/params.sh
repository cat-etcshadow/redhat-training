#!/usr/bin/env bash
LOGFILES=(worker-a.log worker-b.log worker-c.log)
i=$(( RANDOM % ${#LOGFILES[@]} ))
echo "LOG_FILE=/var/log/rhtr-${LOGFILES[$i]}"
