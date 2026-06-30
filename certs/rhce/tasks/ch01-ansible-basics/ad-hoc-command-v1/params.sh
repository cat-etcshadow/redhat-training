#!/usr/bin/env bash
PKGS=(vim-enhanced tmux tree git wget curl)
idx=$(( RANDOM % ${#PKGS[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "SCRIPT_FILE=/home/student/ansible/adhoc.sh"
echo "INSTALL_PKG=${PKGS[$idx]}"
