#!/usr/bin/env bash
# "devuser" excluded — ch03-users/troubleshoot-account-access-v1 hardcodes a
# devuser account with a deliberately expired chage date, which would block
# this task's live SSH login test (grade.sh) via PAM account-expiry checks.
USERS=(sshuser keyuser svcacct)
idx=$(( RANDOM % ${#USERS[@]} ))
echo "SSH_USER=${USERS[$idx]}"
echo "KEY_TYPE=rsa"
