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

print_header
for mp in / /boot; do
  check_mountpoint "$mp"
done
SCRIPT
chmod +x "$SCRIPT_PATH"
