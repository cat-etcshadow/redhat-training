#!/usr/bin/env bash
IDENTIFIERS=(rhtr-webapp rhtr-daemon rhtr-worker rhtr-service rhtr-monitor)
MESSAGES=("Application started successfully" "Service initialization complete" "Worker process launched" "Background service ready" "Monitor activated")
OUTPUT_FILES=(/tmp/rhtr-journal.txt /tmp/rhtr-syslog.txt /tmp/rhtr-app-log.txt /tmp/rhtr-service-log.txt)
BOOT_FILES=(/tmp/rhtr-boot.txt /tmp/rhtr-current-boot.txt /tmp/rhtr-bootlog.txt /tmp/rhtr-bboot.txt)

ii=$(( RANDOM % ${#IDENTIFIERS[@]} ))
im=$(( RANDOM % ${#MESSAGES[@]} ))
io=$(( RANDOM % ${#OUTPUT_FILES[@]} ))
ib=$(( RANDOM % ${#BOOT_FILES[@]} ))

echo "SYSLOG_ID=${IDENTIFIERS[$ii]}"
echo "LOG_MESSAGE=${MESSAGES[$im]}"
echo "OUTPUT_FILE=${OUTPUT_FILES[$io]}"
echo "BOOT_LOG_FILE=${BOOT_FILES[$ib]}"
