#!/usr/bin/env bash
groupadd "$SHARED_GROUP" 2>/dev/null || true
mkdir -p "$SHARED_DIR"
chgrp "$SHARED_GROUP" "$SHARED_DIR"
chmod 3770 "$SHARED_DIR"
