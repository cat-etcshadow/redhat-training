#!/usr/bin/env bash
rm -f "$REPORT_FILE"
# skopeo is installed once during VM provisioning (see container-cache-setup.sh)
# so this stays offline during the actual exam.
if ! podman image exists "$IMAGE" 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null
fi
