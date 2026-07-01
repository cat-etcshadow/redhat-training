#!/usr/bin/env bash
cat > "$SCRIPT_PATH" <<'SCRIPT'
#!/usr/bin/env bash
ITEMS=(widget gadget bolt gear valve)
QTYS=(45 8 120 3 60)

if [[ $# -ne 1 ]]; then
  echo "Usage: inventory_report.sh <threshold>" >&2
  exit 1
fi
threshold="$1"

count=0
for i in "${!ITEMS[@]}"; do
  if (( QTYS[i] < threshold )); then
    echo "LOW: ${ITEMS[i]} (${QTYS[i]})"
    (( count++ ))
  fi
done

echo "Total low-stock items: ${count}"
SCRIPT
chmod +x "$SCRIPT_PATH"
