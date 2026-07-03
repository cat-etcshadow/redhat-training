#!/usr/bin/env bash
ctx1=$(ps -eZ | grep '[h]ttpd' | head -1 | awk '{print $1}')
echo "$ctx1" | cut -d: -f3 > "$OUTPUT_FILE"

ctx2=$(ps -eZ | grep '[s]shd' | head -1 | awk '{print $1}')
echo "$ctx2" | cut -d: -f3 >> "$OUTPUT_FILE"
