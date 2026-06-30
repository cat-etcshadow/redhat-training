#!/usr/bin/env bash
PLAYBOOKS=(multi-pkg.yml stack-deploy.yml app-packages.yml deploy-stack.yml)
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

PKG_SETS=("httpd php-fpm" "nginx nodejs" "mariadb php")
PKG3_OPTS=(python3-flask golang rust)
sidx=$(( RANDOM % ${#PKG_SETS[@]} ))
p3idx=$(( RANDOM % ${#PKG3_OPTS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "PKG_SET=\"${PKG_SETS[$sidx]}\""
echo "PKG1=$(echo "${PKG_SETS[$sidx]}" | awk '{print $1}')"
echo "PKG2=$(echo "${PKG_SETS[$sidx]}" | awk '{print $2}')"
echo "PKG3=${PKG3_OPTS[$p3idx]}"
