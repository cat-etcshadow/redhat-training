#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
  echo "Usage: create_dirs.sh <base-directory>" >&2
  exit 1
fi
base="$1"
for name in logs data config backups tmp; do
  mkdir -p "${base}/${name}"
  echo "This is the ${name} directory" > "${base}/${name}/README"
  echo "Created: ${base}/${name}"
done
SCRIPT
chmod +x "$SCRIPT_PATH"
