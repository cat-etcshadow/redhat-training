#!/usr/bin/env bash
NET_NAMES=(rhtr-net-a rhtr-net-b rhtr-net-c)
SUBNETS=(10.89.10.0/24 10.89.20.0/24 10.89.30.0/24)
CONTAINER_NAMES=(netapp linkedapp connectedapp)

i=$(( RANDOM % ${#NET_NAMES[@]} ))

echo "NET_NAME=${NET_NAMES[$i]}"
echo "SUBNET=${SUBNETS[$i]}"
echo "CONTAINER_NAME=${CONTAINER_NAMES[$i]}"
