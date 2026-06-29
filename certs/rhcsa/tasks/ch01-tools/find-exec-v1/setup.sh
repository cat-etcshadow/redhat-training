#!/usr/bin/env bash
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR/sub1/sub2" "$TARGET_DIR/sub3"
for d in "$TARGET_DIR" "$TARGET_DIR/sub1" "$TARGET_DIR/sub1/sub2" "$TARGET_DIR/sub3"; do
  chmod 0777 "$d"
  for i in 1 2 3; do
    f="${d}/file${i}.txt"
    echo "data $i" > "$f"
    chmod 0777 "$f"
  done
done
