#!/usr/bin/env bash
FROM_PORTS=(8080 8888 9090 7070)
TO_PORTS=(80 8081 3000 5000)

i=$(( RANDOM % ${#FROM_PORTS[@]} ))

echo "FROM_PORT=${FROM_PORTS[$i]}"
echo "TO_PORT=${TO_PORTS[$i]}"
