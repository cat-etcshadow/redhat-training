#!/usr/bin/env bash
USERS=(contractor1 contractor2 intern1 intern2 tempuser1)
i=$(( RANDOM % ${#USERS[@]} ))
OFFSET=$(( 30 + RANDOM % 90 ))
EXPIRE_DATE=$(date -d "+${OFFSET} days" +%Y-%m-%d)
echo "CONTRACT_USER=${USERS[$i]}"
echo "EXPIRE_DATE=${EXPIRE_DATE}"
