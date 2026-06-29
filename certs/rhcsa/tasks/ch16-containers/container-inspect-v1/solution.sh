#!/usr/bin/env bash
podman pull "$IMAGE"
podman inspect "$IMAGE" > "$REPORT_FILE"
skopeo inspect "docker://${IMAGE}" >> "$REPORT_FILE"
podman inspect --format "OS: {{.Os}}  Arch: {{.Architecture}}" "$IMAGE" >> "$REPORT_FILE"
