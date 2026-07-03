#!/usr/bin/env bash
ssh localhost "$REMOTE_SCRIPT" > "$OUT_FILE"
ssh localhost "date +%Y" >> "$OUT_FILE"
