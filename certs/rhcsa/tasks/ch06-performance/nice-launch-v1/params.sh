#!/usr/bin/env bash
USERS=(batchuser jobuser worker-svc analyticsuser)
NICE_VALS=(5 10 15 19)

iu=$(( RANDOM % ${#USERS[@]} ))
in=$(( RANDOM % ${#NICE_VALS[@]} ))

echo "TARGET_USER=${USERS[$iu]}"
echo "NICE_VAL=${NICE_VALS[$in]}"
