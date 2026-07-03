#!/usr/bin/env bash
dnf install -y podman &>/dev/null
podman stop rhtr-execlogs &>/dev/null || true
podman rm -f rhtr-execlogs &>/dev/null || true
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null || true
fi
podman run -d --name rhtr-execlogs registry.access.redhat.com/ubi9/ubi sh -c 'echo "container started"; sleep infinity' &>/dev/null
rm -f "$OUTPUT_FILE"
