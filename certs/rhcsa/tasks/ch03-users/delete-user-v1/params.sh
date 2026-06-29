#!/usr/bin/env bash
NAMES=(tempuser contractor testacct devtemp buildbot svctemp)
GROUPS=(contractors temps devs builders)
idx=$(( RANDOM % ${#NAMES[@]} ))
ig=$(( RANDOM % ${#GROUPS[@]} ))
echo "DEL_USER=${NAMES[$idx]}"
echo "DEL_GROUP=${GROUPS[$ig]}"
