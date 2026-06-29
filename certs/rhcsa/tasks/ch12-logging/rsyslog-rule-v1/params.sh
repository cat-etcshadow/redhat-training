#!/usr/bin/env bash
FACILITIES=(auth daemon cron local0 local1)
SEVERITIES=(crit err warning notice)
LOGFILES=(auth-critical daemon-errors cron-alerts local0-events svc-warnings)
CONFNAMES=(auth-errors daemon-filter cron-alerts local0-capture svc-filter)

idx=$(( RANDOM % ${#FACILITIES[@]} ))
is=$(( RANDOM % ${#SEVERITIES[@]} ))
il=$(( RANDOM % ${#LOGFILES[@]} ))
ic=$(( RANDOM % ${#CONFNAMES[@]} ))

echo "FACILITY=${FACILITIES[$idx]}"
echo "SEVERITY=${SEVERITIES[$is]}"
echo "LOG_FILE=/var/log/${LOGFILES[$il]}.log"
echo "CONF_FILE=/etc/rsyslog.d/${CONFNAMES[$ic]}.conf"
