#!/usr/bin/env bash
DNS1_OPTS=(10.55.10.10 10.66.20.20 192.168.90.10)
DNS2_OPTS=(10.55.10.20 10.66.20.30 192.168.90.20)

i=$(( RANDOM % ${#DNS1_OPTS[@]} ))

echo "DNS1=${DNS1_OPTS[$i]}"
echo "DNS2=${DNS2_OPTS[$i]}"
