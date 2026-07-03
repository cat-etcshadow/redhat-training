#!/usr/bin/env bash
id "$TARGET_USER" &>/dev/null || useradd "$TARGET_USER"
getent group "$TARGET_GROUP" &>/dev/null || groupadd "$TARGET_GROUP"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"
setfacl -m "u:${TARGET_USER}:rwx" "$TARGET_DIR"
setfacl -m "g:${TARGET_GROUP}:rwx" "$TARGET_DIR"
