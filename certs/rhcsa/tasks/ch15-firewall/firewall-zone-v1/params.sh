#!/usr/bin/env bash
ZONE_NAMES=(internal-ops mgmt-net trust-net corp-net lab-net)
SOURCES=(10.10.0.0/16 192.168.100.0/24 172.16.10.0/24 10.20.0.0/24)
SERVICES1=(http https ssh)
SERVICES2=(smtp dns ftp ntp)

iz=$(( RANDOM % ${#ZONE_NAMES[@]} ))
is=$(( RANDOM % ${#SOURCES[@]} ))
is1=$(( RANDOM % ${#SERVICES1[@]} ))
is2=$(( RANDOM % ${#SERVICES2[@]} ))

echo "ZONE_NAME=${ZONE_NAMES[$iz]}"
echo "ZONE_SOURCE=${SOURCES[$is]}"
echo "ZONE_SVC1=${SERVICES1[$is1]}"
echo "ZONE_SVC2=${SERVICES2[$is2]}"
