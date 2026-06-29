## Hint

- `cat > /file <<EOF` + variables → content with `$var` expanded
- `cat > /file <<'EOF'` → content written literally, no variable expansion
- The delimiter (`EOF`) must appear alone on a line to close the here-doc
- Use `<<-EOF` (with dash) to strip leading tabs (not spaces)
- Here-docs work inside functions and loops too
- `"$1"`, `"$2"`, `"$3"` are the positional parameters in the script
