#!/usr/bin/env bash
IPS=(10.0.0.60/24 10.0.0.70/24 10.0.0.80/24)
i=$(( RANDOM % ${#IPS[@]} ))
echo "SECONDARY_IP=${IPS[$i]}"
