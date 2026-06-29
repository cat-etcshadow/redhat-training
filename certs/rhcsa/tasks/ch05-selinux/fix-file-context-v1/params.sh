#!/usr/bin/env bash
DIRS=(secure private content assets uploads media)
idx=$(( RANDOM % ${#DIRS[@]} ))
echo "WEBDIR=${DIRS[$idx]}"
