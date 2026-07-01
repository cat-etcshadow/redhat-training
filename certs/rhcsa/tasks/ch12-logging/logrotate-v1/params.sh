#!/usr/bin/env bash
APPS=(rhtr-webapp rhtr-worker rhtr-gateway)
SIZES=(5M 10M 20M)
ROTATES=(3 5 7)

ia=$(( RANDOM % ${#APPS[@]} ))
is=$(( RANDOM % ${#SIZES[@]} ))
ir=$(( RANDOM % ${#ROTATES[@]} ))

echo "APP_NAME=${APPS[$ia]}"
echo "LOG_FILE=/var/log/${APPS[$ia]}.log"
echo "MAX_SIZE=${SIZES[$is]}"
echo "ROTATE_COUNT=${ROTATES[$ir]}"
