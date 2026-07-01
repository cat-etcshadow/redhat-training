#!/usr/bin/env bash
ZONES=(public external)
i=$(( RANDOM % ${#ZONES[@]} ))
echo "ZONE=${ZONES[$i]}"
