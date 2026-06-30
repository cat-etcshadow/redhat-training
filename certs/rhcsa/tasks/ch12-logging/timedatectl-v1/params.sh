#!/usr/bin/env bash
TIMEZONES=("America/New_York" "Europe/London" "Asia/Tokyo" "Australia/Sydney" "Europe/Berlin" "America/Chicago")
itz=$(( RANDOM % ${#TIMEZONES[@]} ))
echo "TIMEZONE=${TIMEZONES[$itz]}"
