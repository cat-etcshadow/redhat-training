#!/usr/bin/env bash
PORTS=(8090 8180 8280 8380 8480 8580 8880 9180)
ip=$(( RANDOM % ${#PORTS[@]} ))
echo "HTTP_PORT=${PORTS[$ip]}"
