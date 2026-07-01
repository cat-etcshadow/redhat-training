#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
env="${APP_ENV:-development}"
target="${1:-localhost}"

if [[ "$env" != "production" && "$env" != "staging" && "$env" != "development" ]]; then
  echo "Error: invalid APP_ENV '$env'" >&2
  exit 1
fi

echo "Deploying to $target in $env mode"
SCRIPT
chmod +x "$SCRIPT_PATH"
