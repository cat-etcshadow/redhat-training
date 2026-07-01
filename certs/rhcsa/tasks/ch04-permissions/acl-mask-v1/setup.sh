#!/usr/bin/env bash
dnf install -y acl &>/dev/null
getent group "$TARGET_GROUP" &>/dev/null || groupadd "$TARGET_GROUP"

rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"
chmod 750 "$TARGET_DIR"

setfacl -m "g:${TARGET_GROUP}:rwx" "$TARGET_DIR"
# mask restricts the group entry above down to r-x, even though the
# named entry itself grants rwx
setfacl -m m::r-x "$TARGET_DIR"
