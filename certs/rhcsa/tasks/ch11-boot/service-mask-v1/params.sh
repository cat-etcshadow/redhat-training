#!/usr/bin/env bash
UNITS=(rhtr-legacy rhtr-deprecated rhtr-old-agent rhtr-shim)
i=$(( RANDOM % ${#UNITS[@]} ))
echo "UNIT_NAME=${UNITS[$i]}"
