#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -f "$REPORT_FILE" ]] || fail "$REPORT_FILE does not exist"
[[ -s "$REPORT_FILE" ]] || fail "$REPORT_FILE is empty"

# search output must be in report
grep -qi "$SEARCH_TERM" "$REPORT_FILE" \
  || fail "$REPORT_FILE missing search results for '$SEARCH_TERM'"

# target image must be pulled
podman image inspect "$TARGET_IMAGE" &>/dev/null \
  || fail "image '$TARGET_IMAGE' is not pulled"

# local tag must exist
podman image inspect "local/ubi9:latest" &>/dev/null \
  || fail "local/ubi9:latest tag does not exist"

# both must share the same image ID
id_orig=$(podman inspect --format '{{.Id}}' "$TARGET_IMAGE")
id_tag=$(podman inspect --format '{{.Id}}' "local/ubi9:latest")
[[ "$id_orig" == "$id_tag" ]] \
  || fail "local/ubi9:latest has different ID than $TARGET_IMAGE (should be a tag, not a separate pull)"

# registries.conf content must appear in report
grep -qi 'registries\|unqualified' "$REPORT_FILE" \
  || fail "$REPORT_FILE missing registries.conf content"

[[ $errors -eq 0 ]] && exit 0 || exit 1
