#!/usr/bin/env bash
dnf install -y podman &>/dev/null
podman stop "$CONTAINER_NAME" 2>/dev/null || true
podman rm -f "$CONTAINER_NAME" 2>/dev/null || true
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null || true
fi
