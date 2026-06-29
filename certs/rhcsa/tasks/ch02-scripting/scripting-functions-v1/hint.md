## Hint

- Define a function: `function_name() { ... }` or `function function_name { ... }`
- Call with arguments: `check_mountpoint "/var"` — inside, `$1` is the argument
- `mountpoint -q "$path"` returns 0 if path is a mountpoint, 1 if not
- `df -h "$path" | awk 'NR==2{print $3, $2, $5}'` extracts used/size/percent
- `--output` handling: `if [[ "$1" == "--output" ]]; then exec > "$2"; fi`
- `exec > file` redirects all subsequent stdout to a file
