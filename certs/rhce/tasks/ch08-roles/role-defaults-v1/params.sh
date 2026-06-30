#!/usr/bin/env bash
ROLES=(webconfig appsetup siteconfig)
PLAYBOOKS=(apply-role.yml deploy-web.yml configure-web.yml)

ridx=$(( RANDOM % ${#ROLES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "ROLES_DIR=/home/student/ansible/roles"
echo "ROLE_NAME=${ROLES[$ridx]}"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
