#!/usr/bin/env bash
dnf install -y podman
podman run -d \
  --name webserver \
  -p 8080:80 \
  -e APP_ENV=production \
  registry.access.redhat.com/ubi9/ubi \
  sleep infinity
