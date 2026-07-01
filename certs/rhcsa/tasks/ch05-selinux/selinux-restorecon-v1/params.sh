#!/usr/bin/env bash
DIRS=(news updates promo landing)
idx=$(( RANDOM % ${#DIRS[@]} ))
echo "WEBDIR=${DIRS[$idx]}"
