#!/usr/bin/env bash
# remove any existing image with this tag
podman rmi "$IMAGE_TAG" 2>/dev/null || true
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cat > "${BUILD_DIR}/Containerfile" <<EOF
FROM registry.access.redhat.com/ubi9/ubi-minimal
LABEL maintainer="rhtr-training"
ENV GREETING="${HELLO_MSG}"
RUN echo "Build complete"
CMD ["/bin/sh", "-c", "echo \$GREETING"]
EOF

cat > "${BUILD_DIR}/README.txt" <<EOF
Build directory for container image ${IMAGE_TAG}.
The container prints the greeting message when run.
EOF

# ensure ubi9-minimal is available
podman pull registry.access.redhat.com/ubi9/ubi-minimal &>/dev/null || true
