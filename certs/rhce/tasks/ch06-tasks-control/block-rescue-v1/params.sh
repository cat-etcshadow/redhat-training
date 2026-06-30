#!/usr/bin/env bash
FAIL_HOSTS=(node3 node4)
PLAYBOOKS=(block-rescue.yml error-handling.yml resilient-deploy.yml)

fidx=$(( RANDOM % ${#FAIL_HOSTS[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "FAIL_HOST=${FAIL_HOSTS[$fidx]}"
