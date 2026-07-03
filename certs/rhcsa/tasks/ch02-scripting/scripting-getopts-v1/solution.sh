#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
verbose=0
src=""
dest=""

while getopts ":s:d:v" opt; do
  case "$opt" in
    s) src="$OPTARG" ;;
    d) dest="$OPTARG" ;;
    v) verbose=1 ;;
    *) echo "Usage: $0 -s <source-file> -d <dest-dir> [-v]" >&2; exit 1 ;;
  esac
done

if [[ -z "$src" || -z "$dest" ]]; then
  echo "Usage: $0 -s <source-file> -d <dest-dir> [-v]" >&2
  exit 1
fi

if [[ ! -f "$src" ]]; then
  echo "Error: source file $src does not exist" >&2
  exit 2
fi

mkdir -p "$dest"

if [[ $verbose -eq 1 ]]; then
  echo "Copying $src to $dest/$(basename "$src")"
fi

cp "$src" "$dest/"
echo "Backup complete"
exit 0
SCRIPT
chmod +x "$SCRIPT_PATH"
