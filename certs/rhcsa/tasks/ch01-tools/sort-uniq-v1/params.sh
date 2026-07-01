#!/usr/bin/env bash
LOGFILES=(login-attempts.log access-requests.log auth-events.log session-log.log)
USERS=(alice bob carol dave erin frank)

il=$(( RANDOM % ${#LOGFILES[@]} ))
iw=$(( RANDOM % ${#USERS[@]} ))

echo "LOG_FILE=/var/log/${LOGFILES[$il]}"
echo "OUTPUT_FILE=/root/top-user.txt"
echo "TOP_USER=${USERS[$iw]}"
