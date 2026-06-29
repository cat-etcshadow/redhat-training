## Hint

- `while IFS= read -r line; do ... done < "$file"` — the safe way to read a file line by line
- `id "$user" &>/dev/null` returns 0 if user exists, 1 if not — use in an if statement
- `useradd -M "$user"` creates the user without creating a home directory
- `-r` in `read` prevents backslash sequences from being interpreted
- `IFS=` ensures whitespace is not stripped from the beginning/end of each line
