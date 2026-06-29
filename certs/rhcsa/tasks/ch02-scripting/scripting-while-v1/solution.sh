#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
  echo "Usage: create_users_from_file.sh <file>" >&2
  exit 1
fi
input="$1"
if [[ ! -f "$input" ]]; then
  echo "Error: file $input does not exist" >&2
  exit 1
fi
while IFS= read -r username; do
  [[ -z "$username" ]] && continue
  if id "$username" &>/dev/null; then
    echo "SKIP: $username already exists"
  else
    useradd -M "$username"
    echo "CREATED: $username"
  fi
done < "$input"
SCRIPT
chmod +x "$SCRIPT_PATH"
