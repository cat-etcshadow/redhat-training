## Hint

- `$?` holds the exit code of the last command; check it immediately after the command
- `[[ -e "$f" ]]` — exists; `[[ -f "$f" ]]` — regular file; `[[ -r "$f" ]]` — readable
- `[[ -d "$d" ]]` — is a directory
- `cp "$src" "$dest"` then `rc=$?; if [[ $rc -ne 0 ]]; then ...`
- `mkdir -p "$(dirname "$dest")"` creates parent directories
- Send errors to stderr with `>&2`, keep success on stdout
