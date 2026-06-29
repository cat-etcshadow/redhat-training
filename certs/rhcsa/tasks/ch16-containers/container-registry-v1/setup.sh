#!/usr/bin/env bash
rm -f "$REPORT_FILE"
podman rmi "local/ubi9:latest" 2>/dev/null || true
