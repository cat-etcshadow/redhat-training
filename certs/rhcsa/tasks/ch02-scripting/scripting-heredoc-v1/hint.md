## Hint

- `cat > /file <<EOF` + variables → content with `$var` expanded
- The delimiter (`EOF`) must appear alone on a line to close the here-doc
- Use `<<-EOF` (with dash) to strip leading tabs (not spaces)
- `"$1"`, `"$2"`, `"$3"` are the positional parameters in the script
