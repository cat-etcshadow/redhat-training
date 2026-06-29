#!/usr/bin/env bash
find "$SEARCH_DIR" -type f -name "$PATTERN" | sort > "$OUTPUT_FILE"
