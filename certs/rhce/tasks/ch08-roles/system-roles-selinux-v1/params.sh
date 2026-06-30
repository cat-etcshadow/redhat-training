#!/usr/bin/env bash
MODES=(permissive enforcing)
PLAYBOOKS=(selinux.yml configure-selinux.yml selinux-policy.yml)

midx=$(( RANDOM % ${#MODES[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "SELINUX_MODE=${MODES[$midx]}"
