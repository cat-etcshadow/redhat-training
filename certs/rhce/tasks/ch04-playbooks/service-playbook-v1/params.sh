#!/usr/bin/env bash
SERVICES=(vsftpd postfix rsyslog)
FW_SERVICES=(ftp smtp syslog)
PLAYBOOKS=(service-deploy.yml configure-service.yml install-svc.yml)

idx=$(( RANDOM % ${#SERVICES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "SERVICE_NAME=${SERVICES[$idx]}"
echo "FIREWALL_SERVICE=${FW_SERVICES[$idx]}"
