#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
src=""
dest=""

while getopts ":s:d:" opt; do
  case "$opt" in
    s) src="$OPTARG" ;;
    d) dest="$OPTARG" ;;
    *) echo "Usage: $0 -s <source-file> -d <dest-dir>" >&2; exit 1 ;;
  esac
done

if [[ -z "$src" || -z "$dest" ]]; then
  echo "Usage: $0 -s <source-file> -d <dest-dir>" >&2
  exit 1
fi

if [[ ! -f "$src" ]]; then
  echo "Error: source file $src does not exist" >&2
  exit 2
fi

mkdir -p "$dest"
cp "$src" "$dest/"
echo "Backup complete"
exit 0
SCRIPT
chmod +x "$SCRIPT_PATH"
