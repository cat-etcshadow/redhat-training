#!/usr/bin/env bash
TIMEOUTS=(1 3 10 15)
i=$(( RANDOM % ${#TIMEOUTS[@]} ))
echo "TIMEOUT_VAL=${TIMEOUTS[$i]}"
