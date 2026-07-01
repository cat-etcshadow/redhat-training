#!/usr/bin/env bash
PORTS=(2222 2200 2022 22022)
ip=$(( RANDOM % ${#PORTS[@]} ))
echo "SSH_PORT=${PORTS[$ip]}"
