#!/usr/bin/env bash
dnf install -y podman &>/dev/null
podman stop datastore 2>/dev/null || true
podman rm   datastore 2>/dev/null || true
rm -rf /srv/container-data
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  if [[ -f /var/cache/rhtr-ubi9.tar ]]; then
    podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null || true
  else
    echo "WARN: ubi9 image not cached — attempting live pull (internet required)..."
    podman pull registry.access.redhat.com/ubi9/ubi &>/dev/null \
      || echo "WARN: pull failed — run: podman pull registry.access.redhat.com/ubi9/ubi"
  fi
fi
