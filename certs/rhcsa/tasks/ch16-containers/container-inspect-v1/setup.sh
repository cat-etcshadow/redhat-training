#!/usr/bin/env bash
rm -f "$REPORT_FILE"
podman pull "$IMAGE" &>/dev/null || true
dnf install -y skopeo &>/dev/null || true
