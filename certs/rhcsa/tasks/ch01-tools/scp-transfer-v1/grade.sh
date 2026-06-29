#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

SCP_FILE="${SCP_DEST}/payload.tar.gz"
[[ -f "$SCP_FILE" ]] || fail "scp destination $SCP_FILE does not exist"

# compare checksums
src_sum=$(md5sum "$SRC_FILE" | awk '{print $1}')
dst_sum=$(md5sum "$SCP_FILE" | awk '{print $1}')
[[ "$src_sum" == "$dst_sum" ]] \
  || fail "scp file $SCP_FILE checksum differs from source (file may be corrupt or wrong file)"

[[ -d "$RSYNC_DEST" ]] || fail "rsync destination $RSYNC_DEST does not exist"

for f in data/content.txt meta.conf; do
  [[ -f "${RSYNC_DEST}/${f}" ]] \
    || fail "rsync: expected file ${RSYNC_DEST}/${f} is missing"
  diff "${SRC_DIR}/${f}" "${RSYNC_DEST}/${f}" &>/dev/null \
    || fail "rsync: ${RSYNC_DEST}/${f} differs from source"
done

[[ $errors -eq 0 ]] && exit 0 || exit 1
