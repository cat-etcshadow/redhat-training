#!/usr/bin/env bash
USERS=(opuser svcuser deskuser fieldtech)
idx=$(( RANDOM % ${#USERS[@]} ))
echo "TARGET_USER=${USERS[$idx]}"
