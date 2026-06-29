#!/usr/bin/env bash
podman search "$SEARCH_TERM" > "$REPORT_FILE"
podman pull "$TARGET_IMAGE"
podman tag "$TARGET_IMAGE" "local/ubi9:latest"
cat /etc/containers/registries.conf >> "$REPORT_FILE"
podman images >> "$REPORT_FILE"
