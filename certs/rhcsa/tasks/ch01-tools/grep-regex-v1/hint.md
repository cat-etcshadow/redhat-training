## Hint

- `grep -ri 'pattern' /dir` — recursive, case-insensitive search
- `grep -rE 'regex' /dir` — use extended regular expressions
- IPv4 pattern: `[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}`
- `grep -n` adds line numbers; `-l` lists filenames only; `-c` counts matches per file
- Redirect with `>` (overwrite) or `>>` (append)
- The dot `.` in regex matches any character — escape it with `\.` to match a literal dot
