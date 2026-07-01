#!/usr/bin/env bash
SVC_NAMES=(appsvc reportsvc syncsvc metricsvc)
COMMENTS=("Application service account" "Reporting service account" "Sync service account" "Metrics service account")

i=$(( RANDOM % ${#SVC_NAMES[@]} ))

echo "SVC_USER=${SVC_NAMES[$i]}"
echo "SVC_HOME=/opt/${SVC_NAMES[$i]}"
echo "SVC_COMMENT=${COMMENTS[$i]}"
