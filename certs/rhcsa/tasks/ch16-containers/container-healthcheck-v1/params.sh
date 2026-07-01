#!/usr/bin/env bash
NAMES=(healthapp watchedapp probedapp)
i=$(( RANDOM % ${#NAMES[@]} ))
echo "CONTAINER_NAME=${NAMES[$i]}"
