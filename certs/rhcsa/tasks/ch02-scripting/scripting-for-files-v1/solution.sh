#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
if [[ $# -ne 2 ]]; then
  echo "Usage: archive_logs.sh <log-dir> <archive-dir>" >&2
  exit 1
fi
logdir="$1"
archivedir="$2"
mkdir -p "$archivedir"

count=0
for f in $(find "$logdir" -maxdepth 1 -name "*.log" -type f); do
  gzip -c "$f" > "${archivedir}/$(basename "$f").gz"
  echo "Archived: $(basename "$f")"
  (( count++ ))
done

if [[ $count -eq 0 ]]; then
  echo "No log files found in $logdir"
fi
SCRIPT
chmod +x "$SCRIPT_PATH"
