#!/usr/bin/env bash
cat > "$NOISY_SCRIPT" << 'SCRIPT'
#!/usr/bin/env bash
echo "OK: operation completed"
echo "ERROR: something went wrong" >&2
exit 1
SCRIPT
chmod 755 "$NOISY_SCRIPT"

rm -f "$OUT_FILE" "$ERR_FILE"
echo "PREVIOUS_RUN_MARKER" > "$OUT_FILE"
