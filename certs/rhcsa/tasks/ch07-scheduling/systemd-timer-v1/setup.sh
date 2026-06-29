#!/usr/bin/env bash
cat > /usr/local/bin/cleanup.sh <<'SCRIPT'
#!/usr/bin/env bash
find /tmp -name 'rhtr_*' -mmin +60 -delete 2>/dev/null || true
SCRIPT
chmod 755 /usr/local/bin/cleanup.sh
systemctl disable --now cleanup.timer 2>/dev/null || true
rm -f /etc/systemd/system/cleanup.{service,timer}
systemctl daemon-reload
