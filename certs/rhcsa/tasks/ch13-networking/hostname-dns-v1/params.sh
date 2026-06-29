#!/usr/bin/env bash
HOSTS=(server1 node1 srv01 app01 web01 db01)
DOMAINS=(example.com lab.local corp.net training.lab ops.internal)
OCTETS=(10 20 30 40 50)
ih=$(( RANDOM % ${#HOSTS[@]} ))
id=$(( RANDOM % ${#DOMAINS[@]} ))
io=$(( RANDOM % ${#OCTETS[@]} ))
echo "FQDN=${HOSTS[$ih]}.${DOMAINS[$id]}"
echo "SHORTNAME=${HOSTS[$ih]}"
echo "IP_ADDR=192.168.1.${OCTETS[$io]}"
