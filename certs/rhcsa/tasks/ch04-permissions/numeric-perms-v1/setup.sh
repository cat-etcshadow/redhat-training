#!/usr/bin/env bash
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR"

for f in "$FILE1" "$FILE2" "$FILE3" "$FILE4"; do
  echo "content for $f" > "$APP_DIR/$f"
  chmod 777 "$APP_DIR/$f"
done
