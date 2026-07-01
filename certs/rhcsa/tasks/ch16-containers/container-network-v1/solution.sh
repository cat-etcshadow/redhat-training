#!/usr/bin/env bash
podman network create --subnet "$SUBNET" "$NET_NAME"
podman run -d \
  --name "$CONTAINER_NAME" \
  --network "$NET_NAME" \
  registry.access.redhat.com/ubi9/ubi \
  sleep infinity
