#!/usr/bin/env bash
UNIT_NAMES=(rhtr-backup rhtr-monitor rhtr-cleanup rhtr-sync rhtr-audit)
UNIT_SCRIPTS=(rhtr-backup.sh rhtr-monitor.sh rhtr-cleanup.sh rhtr-sync.sh rhtr-audit.sh)
DESCS=("RHTR Backup Service" "RHTR Monitor Service" "RHTR Cleanup Service" "RHTR Sync Service" "RHTR Audit Service")

iu=$(( RANDOM % ${#UNIT_NAMES[@]} ))
echo "UNIT_NAME=${UNIT_NAMES[$iu]}"
echo "UNIT_SCRIPT=${UNIT_SCRIPTS[$iu]}"
echo "UNIT_DESC=${DESCS[$iu]}"
