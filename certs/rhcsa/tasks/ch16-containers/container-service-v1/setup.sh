#!/usr/bin/env bash
dnf install -y podman &>/dev/null
systemctl disable --now container-myapp.service 2>/dev/null || true
podman stop myapp 2>/dev/null || true
podman rm   myapp 2>/dev/null || true
rm -f /etc/systemd/system/container-myapp.service
systemctl daemon-reload
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null || true
fi
