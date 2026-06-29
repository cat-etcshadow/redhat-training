#!/usr/bin/env bash
USERS=(reporter analyst monitor backup worker)
HOURS=(0 1 2 3 4 6)
MINS=(0 15 30 45)
SCRIPTS=(daily-report.sh backup-db.sh cleanup-logs.sh sync-data.sh generate-stats.sh)

iu=$(( RANDOM % ${#USERS[@]} ))
ih=$(( RANDOM % ${#HOURS[@]} ))
im=$(( RANDOM % ${#MINS[@]} ))
is=$(( RANDOM % ${#SCRIPTS[@]} ))

echo "CRON_USER=${USERS[$iu]}"
echo "CRON_HOUR=${HOURS[$ih]}"
echo "CRON_MIN=${MINS[$im]}"
echo "CRON_SCRIPT=/usr/local/bin/${SCRIPTS[$is]}"
