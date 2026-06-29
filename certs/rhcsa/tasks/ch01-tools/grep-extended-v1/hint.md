## Hint

- `grep 'pattern$' file` — `$` anchors the match to end of line
- `grep '/bin/bash$' /etc/passwd` — find all bash users in a colon-delimited file
- `cut -d: -f1` — extract field 1 using `:` as delimiter
- Chain commands with pipes: `grep ... | cut ...` or write to intermediate file
- `-v` inverts the match (lines that do NOT match)
