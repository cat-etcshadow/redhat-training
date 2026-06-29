#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

[[ -d "$EXPORT_DIR" ]] || fail "Export directory $EXPORT_DIR does not exist"

grep -q "$EXPORT_DIR" /etc/exports \
  || fail "$EXPORT_DIR is not listed in /etc/exports"

grep "$EXPORT_DIR" /etc/exports | grep -q "${NFS_CLIENT}" \
  || fail "Client ${NFS_CLIENT} not specified in /etc/exports for ${EXPORT_DIR}"

systemctl is-active nfs-server &>/dev/null || fail "nfs-server is not running"
systemctl is-enabled nfs-server &>/dev/null || fail "nfs-server is not enabled"

exportfs -v 2>/dev/null | grep -q "$EXPORT_DIR" \
  || fail "$EXPORT_DIR is not in active exports (run 'exportfs -r' to reload)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
