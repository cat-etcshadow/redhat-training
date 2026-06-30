#!/usr/bin/env bash
ENVS=(development testing production)
USERS=(devuser testuser produser)
idx=$(( RANDOM % 1 ))  # always 0 — kept for future expansion

echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "DEV_ENV=development"
echo "TEST_ENV=testing"
echo "PROD_ENV=production"
