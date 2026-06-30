#!/usr/bin/env bash
NAMES=(apache.yml httpd.yml webserver.yml deploy-apache.yml)
PORTS=(8080 8443 8000 9000)
idx=$(( RANDOM % ${#NAMES[@]} ))
idxp=$(( RANDOM % ${#PORTS[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "LISTEN_PORT=${PORTS[$idxp]}"
