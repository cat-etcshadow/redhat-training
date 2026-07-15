#!/usr/bin/env bash
dnf install -y podman &>/dev/null
systemctl disable --now container-rhtr-webapp.service 2>/dev/null || true
podman stop rhtr-webapp 2>/dev/null || true
podman rm   rhtr-webapp 2>/dev/null || true
rm -f /etc/systemd/system/container-rhtr-webapp.service
systemctl daemon-reload
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null || true
fi

podman run -d --name rhtr-webapp registry.access.redhat.com/ubi9/ubi sleep infinity &>/dev/null
cd /tmp
podman generate systemd --name rhtr-webapp --files --new &>/dev/null
cp container-rhtr-webapp.service /etc/systemd/system/
systemctl daemon-reload
# deliberately left disabled — the unit works if started manually, but was never enabled for boot
systemctl start container-rhtr-webapp.service &>/dev/null
