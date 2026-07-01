#!/usr/bin/env bash
podman run -d \
  --name "$CONTAINER_NAME" \
  --health-cmd "echo healthy" \
  --health-interval=2s \
  --health-timeout=2s \
  --health-retries=1 \
  registry.access.redhat.com/ubi9/ubi \
  sleep infinity
