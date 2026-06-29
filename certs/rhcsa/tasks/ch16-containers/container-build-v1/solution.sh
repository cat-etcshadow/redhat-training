#!/usr/bin/env bash
podman build -t "$IMAGE_TAG" "$BUILD_DIR"
podman run --rm "$IMAGE_TAG"
