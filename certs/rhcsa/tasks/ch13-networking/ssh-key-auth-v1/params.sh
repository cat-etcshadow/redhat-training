#!/usr/bin/env bash
USERS=(sshuser keyuser svcacct devuser)
idx=$(( RANDOM % ${#USERS[@]} ))
echo "SSH_USER=${USERS[$idx]}"
echo "KEY_TYPE=rsa"
