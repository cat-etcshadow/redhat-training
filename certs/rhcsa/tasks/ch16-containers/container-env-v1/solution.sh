#!/usr/bin/env bash
podman run -d \
  --name "$CONTAINER_NAME" \
  -e "${ENV_KEY}=${ENV_VAL}" \
  -p "${HOST_PORT}:8080" \
  registry.access.redhat.com/ubi9/ubi \
  sleep infinity
