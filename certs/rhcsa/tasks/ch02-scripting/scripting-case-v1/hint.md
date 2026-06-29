## Hint

- `case "$var" in pattern) commands ;; esac` — the basic structure
- Multiple patterns: `start|begin) ...` — matches either
- Catch-all: `*) ... ;;` — matches anything not already matched
- `;;` terminates each branch (like `break` in other languages)
- `"$@"` passes all arguments to a command; here pass just `"$2"` for the service name
- To propagate exit codes, do not add `|| true` around the systemctl calls
