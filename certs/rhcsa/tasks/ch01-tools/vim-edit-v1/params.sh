#!/usr/bin/env bash
HOSTNAMES=(app01.lab.local db01.lab.local web01.lab.local cache01.lab.local)
PORTS=(8080 8443 9090 3000)
TIMEOUTS=(30 60 120 300)

ih=$(( RANDOM % ${#HOSTNAMES[@]} ))
ip=$(( RANDOM % ${#PORTS[@]} ))
it=$(( RANDOM % ${#TIMEOUTS[@]} ))

echo "CONF_FILE=/etc/rhtr-app/server.conf"
echo "NEW_HOSTNAME=${HOSTNAMES[$ih]}"
echo "LISTEN_PORT=${PORTS[$ip]}"
echo "TIMEOUT_VAL=${TIMEOUTS[$it]}"
