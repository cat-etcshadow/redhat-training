#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
  echo "Usage: wait_for_file.sh <path>" >&2
  exit 2
fi
file="$1"
attempt=0
max=5

until [[ -f "$file" ]]; do
  (( attempt++ ))
  if (( attempt >= max )); then
    echo "Timeout waiting for $file" >&2
    exit 1
  fi
  echo "Waiting... (${attempt}/${max})"
  sleep 1
done

echo "File found: $file"
exit 0
SCRIPT
chmod +x "$SCRIPT_PATH"
