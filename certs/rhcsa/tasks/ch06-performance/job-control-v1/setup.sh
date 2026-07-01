#!/usr/bin/env bash
cat > /usr/local/bin/rhtr-worker.sh << 'SCRIPT'
#!/usr/bin/env bash
while true; do
  echo "tick: $(date +%s)"
  sleep 1
done
SCRIPT
chmod +x /usr/local/bin/rhtr-worker.sh

pkill -f rhtr-worker.sh 2>/dev/null || true
sleep 0.2
rm -f "$LOG_FILE"
