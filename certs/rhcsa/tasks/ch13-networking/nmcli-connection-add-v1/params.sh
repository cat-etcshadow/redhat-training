#!/usr/bin/env bash
IFACES=(dummy0 dummy1)
CON_NAMES=(rhtr-test-link rhtr-mgmt-link rhtr-static-link)
IPS=(192.168.55.10/24 192.168.66.20/24 10.55.0.5/24)

ii=$(( RANDOM % ${#IFACES[@]} ))
ic=$(( RANDOM % ${#CON_NAMES[@]} ))
ip_i=$(( RANDOM % ${#IPS[@]} ))

echo "IFACE_NAME=${IFACES[$ii]}"
echo "CON_NAME=${CON_NAMES[$ic]}"
echo "IP_ADDR=${IPS[$ip_i]}"
