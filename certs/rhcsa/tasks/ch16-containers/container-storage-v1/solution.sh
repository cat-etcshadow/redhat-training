#!/usr/bin/env bash
mkdir -p /srv/container-data
chcon -Rt container_file_t /srv/container-data
podman run -d \
  --name datastore \
  -v /srv/container-data:/data:Z \
  registry.access.redhat.com/ubi9/ubi \
  sleep infinity
