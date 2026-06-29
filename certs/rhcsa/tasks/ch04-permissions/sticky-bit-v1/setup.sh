#!/usr/bin/env bash
rm -rf "$SHARED_DIR"
groupdel "$SHARED_GROUP" 2>/dev/null || true
