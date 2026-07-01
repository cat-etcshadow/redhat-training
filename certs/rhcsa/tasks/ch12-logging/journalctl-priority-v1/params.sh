#!/usr/bin/env bash
IDENTIFIERS=(rhtr-billing rhtr-ingest rhtr-scheduler rhtr-gateway)
ERR_MESSAGES=("Failed to connect to database" "Unrecoverable disk write error" "Authentication backend unreachable")
INFO_MESSAGES=("Startup sequence complete" "Cache warmed successfully" "Periodic health check passed")

ii=$(( RANDOM % ${#IDENTIFIERS[@]} ))
ie=$(( RANDOM % ${#ERR_MESSAGES[@]} ))
im=$(( RANDOM % ${#INFO_MESSAGES[@]} ))

echo "SYSLOG_ID=${IDENTIFIERS[$ii]}"
echo "ERR_MESSAGE=${ERR_MESSAGES[$ie]}"
echo "INFO_MESSAGE=${INFO_MESSAGES[$im]}"
echo "OUTPUT_FILE=/root/errors-only.txt"
