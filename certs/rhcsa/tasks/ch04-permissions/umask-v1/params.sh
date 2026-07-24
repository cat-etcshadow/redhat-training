#!/usr/bin/env bash
UMASK_VALUES=(027 037 077 022 002)
# "devuser" excluded — ch03-users/troubleshoot-account-access-v1 hardcodes a
# devuser account with a deliberately expired chage date; this task's
# userdel+useradd would either wipe that expired-account state or (in the
# other setup order) leave this task's own target user expired/inaccessible.
USERS=(umaskuser testop sysop)

iu=$(( RANDOM % ${#UMASK_VALUES[@]} ))
iuu=$(( RANDOM % ${#USERS[@]} ))

echo "UMASK_VAL=${UMASK_VALUES[$iu]}"
echo "UMASK_USER=${USERS[$iuu]}"
