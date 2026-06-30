#!/usr/bin/env bash
NAMES=(loop.yml loops.yml packages-users.yml manage.yml)
PKGSETS=("httpd firewalld vim-enhanced" "vsftpd nfs-utils bind-utils" "chrony rsync at")
USERSETS=("alice bob carol" "operator1 operator2 operator3" "sys1 sys2 sys3")
nidx=$(( RANDOM % ${#NAMES[@]} ))
pidx=$(( RANDOM % ${#PKGSETS[@]} ))
uidx=$(( RANDOM % ${#USERSETS[@]} ))
IFS=' ' read -r PKG1 PKG2 PKG3 <<< "${PKGSETS[$pidx]}"
IFS=' ' read -r USER1 USER2 USER3 <<< "${USERSETS[$uidx]}"
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$nidx]}"
echo "PKG1=$PKG1"
echo "PKG2=$PKG2"
echo "PKG3=$PKG3"
echo "USER1=$USER1"
echo "USER2=$USER2"
echo "USER3=$USER3"
