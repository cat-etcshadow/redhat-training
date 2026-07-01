#!/usr/bin/env bash
SERVICES=(cockpit mountd rpc-bind)
i=$(( RANDOM % ${#SERVICES[@]} ))
echo "SVC_NAME=${SERVICES[$i]}"
