#!/usr/bin/env bash
# remove any existing image with this tag
podman rmi "$IMAGE_TAG" 2>/dev/null || true
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cat > "${BUILD_DIR}/Containerfile" <<EOF
FROM registry.access.redhat.com/ubi9/ubi
LABEL maintainer="rhtr-training"
ENV GREETING="${HELLO_MSG}"
RUN echo "Build complete"
CMD ["/bin/sh", "-c", "echo \$GREETING"]
EOF

cat > "${BUILD_DIR}/README.txt" <<EOF
Build directory for container image ${IMAGE_TAG}.
The container prints the greeting message when run.
EOF

# ubi9/ubi is cached at VM creation (see container-cache-setup.sh) — the
# build's FROM must reference it so `podman build` works fully offline.
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  [[ -f /var/cache/rhtr-ubi9.tar ]] && podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null
fi
