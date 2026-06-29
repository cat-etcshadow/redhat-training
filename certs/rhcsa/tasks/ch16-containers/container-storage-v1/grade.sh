#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d /srv/container-data ]] || fail "/srv/container-data does not exist on the host"

ctx=$(ls -dZ /srv/container-data 2>/dev/null | awk '{print $1}')
echo "$ctx" | grep -q 'container_file_t' \
  || fail "/srv/container-data does not have container_file_t SELinux context (got: $ctx)"

running=$(podman ps --format '{{.Names}}' 2>/dev/null)
echo "$running" | grep -q '^datastore$' || fail "Container 'datastore' is not running"

mounts=$(podman inspect datastore --format '{{.Mounts}}' 2>/dev/null)
echo "$mounts" | grep -q '/srv/container-data' \
  || fail "/srv/container-data not mounted into datastore container"
echo "$mounts" | grep -q '/data' \
  || fail "Container mount point /data not found in datastore"

[[ $errors -eq 0 ]] && exit 0 || exit 1
