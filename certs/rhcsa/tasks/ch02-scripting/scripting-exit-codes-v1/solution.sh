#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 2 ]]; then
  echo "Usage: safe_copy.sh <source> <destination>" >&2
  exit 1
fi
src="$1"
dest="$2"
if [[ ! -e "$src" ]]; then
  echo "Error: $src does not exist" >&2
  exit 2
fi
if [[ ! -r "$src" ]]; then
  echo "Error: $src is not readable" >&2
  exit 3
fi
if [[ -d "$dest" ]]; then
  dest="${dest}/$(basename "$src")"
else
  mkdir -p "$(dirname "$dest")"
fi
cp "$src" "$dest"
rc=$?
if [[ $rc -ne 0 ]]; then
  echo "Error: cp failed with exit code $rc" >&2
  exit 4
fi
echo "Copied $src → $dest"
SCRIPT
chmod +x "$SCRIPT_PATH"
