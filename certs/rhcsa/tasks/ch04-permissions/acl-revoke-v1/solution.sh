#!/usr/bin/env bash
setfacl -x "u:${TARGET_USER}" "$TARGET_DIR"
