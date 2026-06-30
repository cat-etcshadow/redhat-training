#!/usr/bin/env bash
CONTENTS=("Welcome to the exam environment" "Managed by Ansible" "Red Hat Training System")
PLAYBOOKS=(motd-deploy.yml configure-motd.yml deploy-motd.yml)

cidx=$(( RANDOM % ${#CONTENTS[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "CONFIG_CONTENT=${CONTENTS[$cidx]}"
