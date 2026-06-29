#!/usr/bin/env bash
dnf install -y podman &>/dev/null
podman stop datastore 2>/dev/null || true
podman rm   datastore 2>/dev/null || true
rm -rf /srv/container-data
# Ensure ubi9 image is available from the pre-loaded cache
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null || true
fi
