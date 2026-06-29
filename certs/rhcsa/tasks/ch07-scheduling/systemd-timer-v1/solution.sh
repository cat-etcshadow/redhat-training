#!/usr/bin/env bash
cat > /etc/systemd/system/cleanup.service <<'UNIT'
[Unit]
Description=Cleanup temporary files

[Service]
Type=oneshot
ExecStart=/usr/local/bin/cleanup.sh
UNIT

cat > /etc/systemd/system/cleanup.timer <<'UNIT'
[Unit]
Description=Run cleanup every 15 minutes

[Timer]
OnCalendar=*:0/15
Persistent=true

[Install]
WantedBy=timers.target
UNIT

systemctl daemon-reload
systemctl enable --now cleanup.timer
