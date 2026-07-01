#!/usr/bin/env bash
podman run -d \
  --name "$CONTAINER_NAME" \
  --memory="$MEM_LIMIT" \
  --cpus="$CPU_LIMIT" \
  registry.access.redhat.com/ubi9/ubi \
  sleep infinity
