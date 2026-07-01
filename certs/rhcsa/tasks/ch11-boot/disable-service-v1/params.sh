#!/usr/bin/env bash
UNITS=(rhtr-notify rhtr-poller rhtr-agent rhtr-relay rhtr-watcher)
i=$(( RANDOM % ${#UNITS[@]} ))
echo "UNIT_NAME=${UNITS[$i]}"
