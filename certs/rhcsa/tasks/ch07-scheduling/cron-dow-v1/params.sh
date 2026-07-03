#!/usr/bin/env bash
USERS=(reporter analyst monitor backup worker)
HOURS=(0 1 2 3 4 6)
MINS=(0 15 30 45)
SCRIPTS=(daily-report.sh backup-db.sh cleanup-logs.sh sync-data.sh generate-stats.sh)
DOW_PATTERNS=("1,3,5" "2,4" "1-5" "6,0")
DOW_LABELS=("Monday, Wednesday, and Friday" "Tuesday and Thursday" "Monday through Friday" "Saturday and Sunday")

iu=$(( RANDOM % ${#USERS[@]} ))
ih=$(( RANDOM % ${#HOURS[@]} ))
im=$(( RANDOM % ${#MINS[@]} ))
is=$(( RANDOM % ${#SCRIPTS[@]} ))
id=$(( RANDOM % ${#DOW_PATTERNS[@]} ))

echo "CRON_USER=${USERS[$iu]}"
echo "CRON_HOUR=${HOURS[$ih]}"
echo "CRON_MIN=${MINS[$im]}"
echo "CRON_SCRIPT=/usr/local/bin/${SCRIPTS[$is]}"
echo "DOW_PATTERN=${DOW_PATTERNS[$id]}"
echo "DOW_LABEL=${DOW_LABELS[$id]}"
