#!/usr/bin/env bash
grep "/bin/${TARGET_SHELL}$" "$INPUT_FILE" > "$OUTPUT_USERS"
cut -d: -f1 "$OUTPUT_USERS" > "$OUTPUT_NAMES"
