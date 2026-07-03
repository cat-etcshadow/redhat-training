#!/usr/bin/env bash
CAPS=(8 12 16)
i=$(( RANDOM % ${#CAPS[@]} ))
echo "VACUUM_CAP=${CAPS[$i]}M"
