#!/usr/bin/env bash
NAMES=(tempuser contractor testacct devtemp buildbot svctemp)
GROUP_NAMES=(contractors temps devs builders)
idx=$(( RANDOM % ${#NAMES[@]} ))
ig=$(( RANDOM % ${#GROUP_NAMES[@]} ))
echo "DEL_USER=${NAMES[$idx]}"
echo "DEL_GROUP=${GROUP_NAMES[$ig]}"
