#!/usr/bin/env bash
SCRIPTS=(rhtr-noisy-a.sh rhtr-noisy-b.sh rhtr-noisy-c.sh)
i=$(( RANDOM % ${#SCRIPTS[@]} ))

echo "NOISY_SCRIPT=/usr/local/bin/${SCRIPTS[$i]}"
echo "OUT_FILE=/root/stdout.log"
echo "ERR_FILE=/root/stderr.log"
