#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash

print_header() {
  echo "=== Disk Usage Report: $(date +%Y-%m-%d) ==="
}

check_mountpoint() {
  local path="$1"
  if mountpoint -q "$path" 2>/dev/null; then
    local info
    info=$(df -h "$path" | awk 'NR==2{printf "%s/%s (%s)", $3, $2, $5}')
    printf "OK   %-10s %s\n" "$path" "$info"
  else
    printf "WARN %-10s NOT MOUNTED\n" "$path"
  fi
}

main() {
  print_header
  for mp in / /boot /tmp /var; do
    check_mountpoint "$mp"
  done
}

if [[ "${1:-}" == "--output" && -n "${2:-}" ]]; then
  main > "$2"
else
  main
fi
SCRIPT
chmod +x "$SCRIPT_PATH"
