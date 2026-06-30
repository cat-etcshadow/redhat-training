#!/usr/bin/env bash
USERS=(apache nginx nobody)
uidx=$(( RANDOM % ${#USERS[@]} ))

PLAYBOOKS=(escalation.yml priv-test.yml become-demo.yml)
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "TARGET_USER=${USERS[$uidx]}"
