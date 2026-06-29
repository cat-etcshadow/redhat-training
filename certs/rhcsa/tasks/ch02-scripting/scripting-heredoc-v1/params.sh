#!/usr/bin/env bash
USERS=(webadmin svcuser appuser deploybot)
PORTS=(8080 8443 9090 9443 3000)
iu=$(( RANDOM % ${#USERS[@]} ))
ip=$(( RANDOM % ${#PORTS[@]} ))
echo "SCRIPT_PATH=/usr/local/bin/gen_config.sh"
echo "APP_USER=${USERS[$iu]}"
echo "APP_PORT=${PORTS[$ip]}"
echo "CONFIG_DIR=/opt/rhtr_genconf"
