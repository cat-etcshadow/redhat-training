#!/usr/bin/env bash
ROOTS=(/srv/website /srv/webcontent /opt/webroot /srv/company-site)
BANNERS=("Welcome to Prod" "Company Portal" "Internal Web Service" "Prod Web Frontend")
NAMES=(deploy_web.yml site.yml webserver.yml prod_web.yml)

ridx=$(( RANDOM % ${#ROOTS[@]} ))
bidx=$(( RANDOM % ${#BANNERS[@]} ))
nidx=$(( RANDOM % ${#NAMES[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$nidx]}"
echo "WEB_ROOT=${ROOTS[$ridx]}"
echo "BANNER_TEXT=${BANNERS[$bidx]}"
