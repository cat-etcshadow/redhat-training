## Hint

- `find /dir -type f -name "*.ext"` — find only regular files with a given extension
- `-type f` excludes directories and symlinks
- Pipe through `sort` to alphabetize: `find ... | sort > output.txt`
- `-iname` is case-insensitive; use `-name` (case-sensitive) here
- `-maxdepth N` limits recursion depth if needed
