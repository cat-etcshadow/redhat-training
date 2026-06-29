## Hint

- Loop over command output: `for f in $(find /dir -name "*.log"); do`
- Or use a glob: `for f in /dir/*.log; do`
- `basename "$f"` strips the directory path, leaving just the filename
- `gzip -c file > dest.gz` compresses to stdout, redirected to a file (original preserved)
- `gzip file` compresses in place (replaces the original) — use `-c` to keep original
- `[[ $# -ne 2 ]]` checks argument count
