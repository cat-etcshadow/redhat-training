#!/usr/bin/env bash
LOGFILES=(worker-x.log worker-y.log worker-z.log)
i=$(( RANDOM % ${#LOGFILES[@]} ))
echo "LOG_FILE=/var/log/rhtr-${LOGFILES[$i]}"
