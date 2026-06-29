#!/usr/bin/env bash
podman run -d --name myapp registry.access.redhat.com/ubi9/ubi sleep infinity
cd /tmp
podman generate systemd --name myapp --files --new
cp container-myapp.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now container-myapp.service
