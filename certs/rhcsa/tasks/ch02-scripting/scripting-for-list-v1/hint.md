## Hint

- `for item in a b c d; do ... done` — iterate over a literal list
- `mkdir -p "$dir"` — create directory (and parents) without error if it exists
- `echo "text" > "$file"` — write (overwrite) a file
- `$1` is the first argument; check it with `[[ -z "$1" ]]` or `[[ $# -eq 0 ]]`
- Use double-quotes around variables to handle spaces in paths
