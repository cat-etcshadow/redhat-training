#!/usr/bin/env bash
TAGS=(myapp:v1 webserver:latest appserver:1.0 svcimage:prod)
MSGS=("Hello from container" "Service ready" "App started" "Running OK")
idx=$(( RANDOM % ${#TAGS[@]} ))
echo "IMAGE_TAG=${TAGS[$idx]}"
echo "HELLO_MSG=${MSGS[$idx]}"
echo "BUILD_DIR=/opt/rhtr_build"
