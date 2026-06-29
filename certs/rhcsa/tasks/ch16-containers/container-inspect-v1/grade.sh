#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$REPORT_FILE" ]] || fail "$REPORT_FILE does not exist"
[[ -s "$REPORT_FILE" ]] || fail "$REPORT_FILE is empty"

# image must be locally present
podman image inspect "$IMAGE" &>/dev/null \
  || fail "image '$IMAGE' is not pulled locally"

# report must contain podman inspect JSON (Id field is characteristic)
grep -qi '"Id"\|"id"' "$REPORT_FILE" \
  || fail "$REPORT_FILE missing 'Id' field (podman inspect output not saved)"

# report must contain skopeo output (Architecture field)
grep -qi '"Architecture"\|Architecture\|Digest' "$REPORT_FILE" \
  || fail "$REPORT_FILE missing skopeo output (Architecture or Digest field expected)"

# skopeo must be installed
command -v skopeo &>/dev/null || fail "skopeo is not installed"

[[ $errors -eq 0 ]] && exit 0 || exit 1
