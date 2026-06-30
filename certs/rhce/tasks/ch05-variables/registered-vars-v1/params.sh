#!/usr/bin/env bash
SERVICES=(httpd sshd chronyd)
PLAYBOOKS=(register-test.yml check-services.yml svc-status.yml)

sidx=$(( RANDOM % ${#SERVICES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "CHECK_SERVICE=${SERVICES[$sidx]}"
