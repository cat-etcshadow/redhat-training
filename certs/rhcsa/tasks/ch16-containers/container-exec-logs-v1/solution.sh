#!/usr/bin/env bash
podman exec rhtr-execlogs sh -c "echo 'hello from exec' > /tmp/${MARKER_FILE}"
podman logs rhtr-execlogs > "$OUTPUT_FILE"
