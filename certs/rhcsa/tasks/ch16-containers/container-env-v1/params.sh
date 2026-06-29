#!/usr/bin/env bash
HOST_PORTS=(8100 8200 8300 8400 8500)
CONTAINER_NAMES=(myapp webapp svcapp testapp demoapp)
ENV_KEYS=(APP_ENV APP_MODE RUN_ENV DEPLOY_ENV STAGE)
ENV_VALS=(production staging development testing qa)

ip=$(( RANDOM % ${#HOST_PORTS[@]} ))
ic=$(( RANDOM % ${#CONTAINER_NAMES[@]} ))
ik=$(( RANDOM % ${#ENV_KEYS[@]} ))
iv=$(( RANDOM % ${#ENV_VALS[@]} ))

echo "HOST_PORT=${HOST_PORTS[$ip]}"
echo "CONTAINER_NAME=${CONTAINER_NAMES[$ic]}"
echo "ENV_KEY=${ENV_KEYS[$ik]}"
echo "ENV_VAL=${ENV_VALS[$iv]}"
