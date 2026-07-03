#!/usr/bin/env bash
DIRS=(/srv/rhtr_acl1 /srv/rhtr_acl2 /srv/rhtr_acl3)
USERS=(quinn ivy oscar)
GROUPS=(auditors reviewers analysts)
i=$(( RANDOM % ${#DIRS[@]} ))
echo "TARGET_DIR=${DIRS[$i]}"
echo "TARGET_USER=${USERS[$i]}"
echo "TARGET_GROUP=${GROUPS[$i]}"
