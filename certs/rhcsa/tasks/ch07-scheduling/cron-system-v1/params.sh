#!/usr/bin/env bash
NAMES=(backup-sync log-rotate-check db-vacuum cache-warm)
USERS=(sysbackup reportsvc dbmaint cachesvc)
INTERVALS=(5 10 15 30)

i=$(( RANDOM % ${#NAMES[@]} ))
iu=$(( RANDOM % ${#USERS[@]} ))
ii=$(( RANDOM % ${#INTERVALS[@]} ))

echo "CRON_FILE=/etc/cron.d/rhtr-${NAMES[$i]}"
echo "CRON_USER=${USERS[$iu]}"
echo "SCRIPT_PATH=/usr/local/bin/${NAMES[$i]}.sh"
echo "INTERVAL_MIN=${INTERVALS[$ii]}"
