#!/usr/bin/env bash
dnf install -y podman &>/dev/null
podman stop rhtr-lifecycle-a rhtr-lifecycle-b &>/dev/null || true
podman rm -f rhtr-lifecycle-a rhtr-lifecycle-b &>/dev/null || true
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null || true
fi
podman run -d --name rhtr-lifecycle-a registry.access.redhat.com/ubi9/ubi sleep infinity &>/dev/null
podman run -d --name rhtr-lifecycle-b registry.access.redhat.com/ubi9/ubi sleep infinity &>/dev/null
