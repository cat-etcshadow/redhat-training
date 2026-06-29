#!/usr/bin/env bash
USERS=(conuser svcrunner apprunner poduser)
CONTAINERS=(myapp-svc webapp-svc backend-svc api-svc)
idx=$(( RANDOM % ${#USERS[@]} ))
echo "CTR_USER=${USERS[$idx]}"
echo "CTR_NAME=${CONTAINERS[$idx]}"
