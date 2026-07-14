#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <used> <total>" >&2
  exit 3
fi

used="$1"
total="$2"

if ! [[ "$used" =~ ^[0-9]+$ && "$total" =~ ^[0-9]+$ ]]; then
  echo "Error: <used> and <total> must be non-negative integers" >&2
  exit 3
fi

pct=$(( used * 100 / total ))
echo "Usage: ${pct}%"

if (( pct >= 80 )); then
  echo "WARNING"
  exit 1
else
  echo "OK"
  exit 0
fi
SCRIPT
chmod +x "$SCRIPT_PATH"
