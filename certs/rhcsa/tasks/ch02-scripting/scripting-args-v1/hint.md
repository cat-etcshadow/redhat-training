## Hint

- `$#` — number of arguments; `$1`, `$2` — individual positional parameters
- `$0` — the script name itself (useful in usage messages)
- `[[ -f "$1" ]]` — test if argument 1 is a regular file
- `[[ -d "$2" ]] || mkdir -p "$2"` — create directory if missing
- `basename "$1"` — strip the path, leaving only the filename
- `$(date +%Y%m%d-%H%M%S)` — generate a datestamp string
- `cp "$src" "$dest"` — copy a file
