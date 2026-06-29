#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 2 ]]; then
  echo "Usage: backup_file.sh <source-file> <destination-dir>" >&2
  exit 1
fi
src="$1"
destdir="$2"
if [[ ! -f "$src" ]]; then
  echo "Error: $src does not exist or is not a regular file" >&2
  exit 2
fi
mkdir -p "$destdir"
ts=$(date +%Y%m%d-%H%M%S)
dest="${destdir}/$(basename "$src").${ts}"
cp "$src" "$dest"
echo "Backed up $src to $dest"
SCRIPT
chmod +x "$SCRIPT_PATH"
