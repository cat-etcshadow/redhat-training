#!/usr/bin/env bash
NAMES=(firewall.yml fw-rules.yml open-ports.yml network-security.yml)
SERVICES=(http https ftp smtp)
PORTS=(8080 8443 9090 3000)
idx=$(( RANDOM % ${#NAMES[@]} ))
sidx=$(( RANDOM % ${#SERVICES[@]} ))
pidx=$(( RANDOM % ${#PORTS[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "FW_SERVICE=${SERVICES[$sidx]}"
echo "FW_PORT=${PORTS[$pidx]}"
