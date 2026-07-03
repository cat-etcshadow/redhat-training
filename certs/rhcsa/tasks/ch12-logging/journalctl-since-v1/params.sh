#!/usr/bin/env bash
IDENTIFIERS=(rhtr-sync rhtr-worker rhtr-loader rhtr-agent)
DECOY_MESSAGES=("Old startup message" "Previous run complete" "Stale cache notice")
KEEP_MESSAGES=("Current run started" "Fresh sync complete" "New task accepted")

ii=$(( RANDOM % ${#IDENTIFIERS[@]} ))
id=$(( RANDOM % ${#DECOY_MESSAGES[@]} ))
ik=$(( RANDOM % ${#KEEP_MESSAGES[@]} ))

echo "SYSLOG_ID=${IDENTIFIERS[$ii]}"
echo "DECOY_MESSAGE=${DECOY_MESSAGES[$id]}"
echo "KEEP_MESSAGE=${KEEP_MESSAGES[$ik]}"
echo "SINCE_TS=$(date -d '+3 seconds' '+%Y-%m-%d %H:%M:%S')"
echo "OUTPUT_FILE=/root/since-filtered.txt"
