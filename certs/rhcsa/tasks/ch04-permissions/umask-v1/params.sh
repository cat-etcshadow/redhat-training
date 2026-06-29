#!/usr/bin/env bash
UMASK_VALUES=(027 037 077 022 002)
USERS=(umaskuser testop devuser sysop)

iu=$(( RANDOM % ${#UMASK_VALUES[@]} ))
iuu=$(( RANDOM % ${#USERS[@]} ))

echo "UMASK_VAL=${UMASK_VALUES[$iu]}"
echo "UMASK_USER=${USERS[$iuu]}"
