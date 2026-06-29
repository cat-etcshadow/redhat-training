#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

# image must exist
podman image inspect "$IMAGE_TAG" &>/dev/null \
  || fail "image '$IMAGE_TAG' does not exist — run 'podman build -t $IMAGE_TAG $BUILD_DIR'"

# image must have been built from the Containerfile (check label)
podman inspect "$IMAGE_TAG" --format '{{.Config.Labels}}' 2>/dev/null | grep -qi 'rhtr-training' \
  || fail "image '$IMAGE_TAG' missing expected label (was it built from the provided Containerfile?)"

# running the image must produce the expected message
output=$(podman run --rm "$IMAGE_TAG" 2>/dev/null)
[[ "$output" == "$HELLO_MSG" ]] \
  || fail "container output is '$output', expected '$HELLO_MSG'"

[[ $errors -eq 0 ]] && exit 0 || exit 1
