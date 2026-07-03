#!/usr/bin/env bash
USERS=(marcus elena tariq nadia ravi)
i=$(( RANDOM % ${#USERS[@]} ))
echo "WHEEL_USER=${USERS[$i]}"
