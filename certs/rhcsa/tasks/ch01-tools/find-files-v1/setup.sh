#!/usr/bin/env bash
rm -rf "$SEARCH_DIR"
mkdir -p "$SEARCH_DIR/subA/subB" "$SEARCH_DIR/subC"

# matching files
for i in 1 2 3; do
  echo "content $i" > "$SEARCH_DIR/file${i}.${FILE_EXT}"
done
echo "nested" > "$SEARCH_DIR/subA/nested.${FILE_EXT}"
echo "deep"   > "$SEARCH_DIR/subA/subB/deep.${FILE_EXT}"

# non-matching files (different extensions)
echo "readme"  > "$SEARCH_DIR/README.md"
echo "binary"  > "$SEARCH_DIR/subC/data.bin"
echo "image"   > "$SEARCH_DIR/photo.jpg"

rm -f "$OUTPUT_FILE"
